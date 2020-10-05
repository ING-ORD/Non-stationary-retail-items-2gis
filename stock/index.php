<?php

session_start();

//conect to DB
$pdo = require_once('./database.php');

$url = explode('?', $_SERVER['REQUEST_URI']);
$url = $url[0];

$data = ($_SERVER["REQUEST_METHOD"] == "GET") ? $_GET :  $_POST ;

$request = [
    "method"  => $_SERVER["REQUEST_METHOD"],
    "url"     => $url,
    "data"    => $data,
];

function error404 () {
    
    echo json_encode([ "error"=>"404" ]);
}

function issetOrIsset ($data, $model_field){
    $isset = false;
    foreach ($model_field as $value){
        $isset = ($isset or isset($data[$value]));
    }
    return $isset;
}

if ($request["method"] == "GET"){
    if ($request["url"] == "/") {

        require_once("./pages/main.php");

    } else if ($request["url"] == "/api/points") {

        // Проверка существования сесси 
        if ( !isset($_SESSION["session_token"]) ){

            $query_points_table = $pdo->query('SELECT `id`, `name`, `description`, `x`, `y`, `img_link` FROM `points`;'); // выгрузка всех точек

            $session_token = session_create_id(); // создаю токен сесси
            $_SESSION["session_token"] = $session_token;

            $insert_session_upload_points = $pdo->prepare("INSERT INTO `session_upload_points` (`session`, `date_upload_points` ) VALUES (:session , :date );");
            $insert_session_upload_points->execute(
                [
                    "session"=>$session_token,
                    "date"   =>time()
                ]
            ); // добавляю сессию

        } else {

            $date_upload_points = $pdo->query("SELECT `date_upload_points` FROM `session_upload_points` WHERE `session_upload_points`.`session` = '". $_SESSION["session_token"] ."';")->fetch()["date_upload_points"]; 

            $query_points_table = $pdo->prepare('SELECT `id`, `name`, `description`, `x`, `y`, `img_link` FROM `points` WHERE `points`.`updated_at` > :dateUploadPoints ;'); // выгрузка новых точек
            $query_points_table->execute(
                [
                    "dateUploadPoints" => $date_upload_points
                ]
            );

            $update_date_upload_points = $pdo->prepare("UPDATE `session_upload_points` SET `date_upload_points` = :date WHERE `session_upload_points`.`session` = :session ");
            $update_date_upload_points->execute(
                [
                    "session"=>$_SESSION["session_token"],
                    "date"   =>time()
                ]
            );

        }

       
        $points = $query_points_table->fetchAll();

        header('Content-Type: application/json');
        echo json_encode( ["points"=>$points, "date" => time() ] );
        die();

    } else if ($request["url"] == "/api/force") {

        $_SESSION = array();
        echo "url: /";
        die();

    } else {
        header('Content-Type: application/json');
        error404(); 
        die();
    }
}
else if ($request["method"] == "POST") {
    
    if ($request["url"] == "/api/edit/point") {
        $data = $request["data"];
        $valid_data = [];
        $query_data = [];
        $model_field = [
            'name',
            'description',
            'x', 
            'y', 
            'img_link'
        ];// здесь те поля который нужно заполнять

        if (empty($data)) {
            header('Content-Type: application/json');
            echo json_encode(["error"=>"parameters cannot be omitted", "params"=>$data, "GET"=> $_GET,"POST"=> $_POST]);
            die;
        } 

        //проверка на существование id и любого поля name, coordinates или img_link
        // if (issetOrIsset($data, $model_field)) {
        //     echo "!";
        // }else {
        //     echo "?";
        // }
        if (!(isset($data["id"]) and issetOrIsset($data, $model_field) ) ) { 
            header('Content-Type: application/json');
            echo json_encode(["error"=>"invalid parameters", "params"=>$data, "GET"=> $_GET,"POST"=> $_POST]); 
            die();
        }

        // создание массива с изменяемыми параметрами и формируем массив валидных данных
        foreach ($data as $key => $value){
            if (!in_array($key, $model_field)) continue;

            $valid_data[$key] = $value;

            if (empty($query_data)){ //если массив пустой значит первый параметр запроса должен быть без запятой

                $query_data[] = $key."= :".$key;

            }else{ // иначе с запятой в начале

                $query_data[] = " , ".$key."= :".$key;

            }
        }

        // формируем запрос
        $query_update_point = "UPDATE `points` set ";
        foreach ($query_data as $value){
            $query_update_point .= $value;
        }
        $query_update_point .= ", updated_at = '".time()."'"; // обновляем время
        $query_update_point .= " WHERE `id` = '".$data["id"]."';";

        $q = $pdo->prepare($query_update_point);
        $q->execute($valid_data);

        $new_point = $pdo->prepare("SELECT `id`, `name`, `description`, `x`, `y`, `img_link` FROM `points` WHERE `id` = :id ;");
        $new_point->execute(["id"=>$data["id"]]);
        $new_point = $new_point->fetch();

        header('Content-Type: application/json');
        echo json_encode($new_point);
        die();

    } else {
        header('Content-Type: application/json');
        error404(); // return default json if not found route
        die();
    }
}


