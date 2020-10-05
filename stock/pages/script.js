
setInterval(() => {
    response = fetch('http://tyumen/api/points' , {
        method: "GET",
        headers:{
            'Accept':'application/json',
            'Content-Type':'application/json',
        },
    }).then(response => response.json())
    .then(data => {
        let points = cache_data(data);
        draw_template_table(points);
        draw_points_on_map(points)
    });
}, 10*1000);

function redraw_template_table () {
    let points = cache_data();
    draw_template_table(points);
} 

function draw_template_table (points) {

    let template_table = document.getElementById("template-table");

    let template = Handlebars.compile("\
    <table>\
        <tr>\
            <th>№</th>\
            <th>Имя</th>\
            <th>Координаты</th>\
            <th>Действия</th>\
        </tr>\
        {{#each points}}\
            <tr>\
                <td>{{id}}</td>\
                <td>{{name}}</td>\
                <td>x:{{x}}, y:{{y}}</td>\
                <td><button data-id='{{id}}' class='action-btn'>Открыть карточку</button></td>\
            </tr>\
        {{/each}}\
    </table>");
    
    let html = template({ "points":points });
    template_table.innerHTML = html;

    let buttons = document.querySelectorAll("button.action-btn");

    buttons.forEach((button, key) => {
        button.onclick = (e)=>{


            draw_template_popup(points.find((p)=> p.id == e.target.dataset.id ));

            clear_table();

            // console.log(e.target.dataset.id);
        }
    })
}

function clear_table (){
    document.getElementById("template-table").innerHTML = "";
}

function draw_points_on_map (points){

    let map;

    let divMap = document.createElement("div");
    divMap.setAttribute("id", "map");

    DG.then(function () {
        map = DG.map(divMap, {
            center: [57.151777, 65.537114],
            zoom: 17,
            minZoom: 16,
            maxZoom: 17,
            zoomControl: false,
            fullscreenControl: false,
        });

        for (let point of points) {
            let icon = DG.icon({
                iconUrl: point.img_link,
                iconSize: [24, 24],
            });
            
            console.log("draw: ", point);

            DG.marker([point.x, point.y], {icon}).addTo(map).bindPopup(html_template_popup_2gis(point));
        }
    });

    document.querySelector(".map-wrap").innerHTML = "";
    document.querySelector(".map-wrap").appendChild(divMap);

}

function html_template_popup_2gis (point){


    let template = Handlebars.compile('\
    <h3>{{name}}</h3>\
    <hr>\
    <div class="description">\
        <h4>Описание</h4>\
        <p>{{description}}</p>\
    </div>\
    <br>\
    <button id="in_action-btn" >Открыть карточку объекта</button>');

    let html = template(point);

    let answer_html = document.createElement('div');
    answer_html.innerHTML = html;

    answer_html.querySelector("button").onclick = function () {
        clear_table();
        draw_template_popup(point);
    }

    return answer_html
}

function draw_template_popup (context) {

    let template_popup = document.getElementById("template-popup");
    template_popup.classList.add("active");

    let template = Handlebars.compile('\
    <form id="change-point">\
        <div class="field">\
            <input type="text" name="id" disabled id="id_field" value={{id}}>\
            <span>№</span>\
        </div>\
        <div class="field">\
            <input type="text" name="name" id="name_field" value={{name}}>\
            <span>Имя</span>\
        </div>\
        <div class="field">\
            <textarea rows="6" cols="45" name="description" id="description_field" >{{description}}</textarea>\
            <span>Описание</span>\
        </div>\
        <div class="field">\
            <input type="text" name="x" id="x_field" value={{x}}>\
            <span>Долгота</span>\
        </div>\
        <div class="field">\
            <input type="text" name="y" id="y_field" value={{y}}>\
            <span>Широта</span>\
        </div>\
        <div class="field-img" >\
            <select id="img-link_field"  name="img_link">\
                <option value="https://34kjmn3xy614nqsp3bsgpb13-wpengine.netdna-ssl.com/wp-content/uploads/2018/11/small-business-storefront-icon-RED-BLUE.svg">Павильон</option>\
                <option value="https://www.svgrepo.com/show/217870/tent.svg">Палатка</option>\
                <option value="https://www.flaticon.com/svg/static/icons/svg/287/287623.svg">Киоск</option>\
            </select>\
            <span>Картинка</span>\
        </div>\
    </form>\
    <button class="save-btn">Сохранить</button>\
    <button class="cancel-btn">Отмена</button>\
    ');

    let html = template(context);
    template_popup.innerHTML = html;

    let buttonCancel = document.querySelector("button.cancel-btn");
    let buttonSave = document.querySelector("button.save-btn");

    buttonSave.onclick = function (e) {
        let inputs = document.querySelectorAll("#change-point input");
        let data = [];
        for (input of inputs){
            data[input.name] = input.value;
        }
        
        let textarea = document.querySelector("#change-point textarea")
        data[textarea.name] = textarea.innerHTML;

        let select = document.querySelector("#change-point select")
        data[select.name] = select.value;

        let formData = new FormData();
        for (let key in data){
            formData.append(key, data[key]);
        }
        
        fetch('http://tyumen/api/edit/point' , {
            method: "POST",
            // headers:{
            //     'Accept':'application/json',
            //     "Content-type": "application/form-data; charset=UTF-8",
            // },
            body: formData,
        }).then(response => response.json())
        .then(data => {
            
            let points = cache_data({"points":[data]});
            draw_template_table(points);
            draw_points_on_map(points);
            clear_popup();
        });
    };

    buttonCancel.onclick = function (e) {
        clear_popup();
        redraw_template_table();
    };


}

function clear_popup (){
    let popup = document.getElementById("template-popup");
    popup.classList.remove("active");
    popup.innerHTML = "";
}

function cache_data (data) {

    let points = data ? data.points : [];

    if (localStorage.getItem('points') !== null) {
        if (points.length == 0) return JSON.parse(localStorage.getItem('points') );
        let localPoints = JSON.parse(localStorage.getItem('points'));

        let newPoints = [];
        // мерж локальных точек и полученых точек, по одинаковым id
        for (let localValue of localPoints ) {

            let point = points.find(e => e.id === localValue.id)
            if (point != undefined ) {

                newPoints.push(point);

            } else {

                newPoints.push(localValue);

            }
        }

        localStorage.setItem('points',JSON.stringify(newPoints) )
        return newPoints;


    } else {

        localStorage.setItem('points',JSON.stringify(points) )
        return points;

    }

}
