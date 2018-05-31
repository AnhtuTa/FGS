
var selectCity = document.getElementsByClassName("select_city")[0];
var selectDistrict = document.getElementsByClassName("select_district")[0];
selectCity.addEventListener("change", function() {
    console.log(selectCity.value);
    //clear data of district dropdown
    selectDistrict.innerHTML = "";

    //request data for district dropdown using AJAX
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var districts = JSON.parse(this.responseText).data.districts;   //districts là 1 mảng JSON

            var data = "";
            for(var i = 0; i < districts.length; i++) {
                data += '<option value="' + districts[i].id + '">' + districts[i].prefix + ' ' + districts[i].name + '</option>';
            }

            //set new data for district dropdown
            selectDistrict.innerHTML = data;
        }
    };

    var query =
        `query {
            districts(province_id: ` + selectCity.value + `) {
            id
            name
            prefix
          }
        }`;
    xhttp.open("GET", "/graphql?query=" + escape(query), true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send();

});