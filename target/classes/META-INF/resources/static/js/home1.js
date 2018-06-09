/*========== switch tab content ==============*/
var tablinks_hotel_nhatro = document.getElementById("tab_wrapper_hotel_nhatro").getElementsByClassName("tablink_wrapper2")[0].getElementsByClassName("tablink");
var tabcontents_hotel_nhatro = document.getElementById("tab_wrapper_hotel_nhatro").getElementsByClassName("tabcontent");

for (var i = 0; i < tablinks_hotel_nhatro.length; i++) {
    tablinks_hotel_nhatro[i].addEventListener("click", showTab_hotel_nhatro.bind({position: i}));	//Trói đít, nhầm, trói this lại bằng bind.
}

//show tab thứ this.position, và active tablink thứ this.position
function showTab_hotel_nhatro() {
    //phải chắc chắn rẳng tabcontents và tablinks có cùng size (Hiển nhiên!)
    for (i = 0; i < tabcontents_hotel_nhatro.length; i++) {
        // Get all elements with class="tabcontent" and hide them
        tabcontents_hotel_nhatro[i].style.display = "none";

        // Get all elements with class="tablinks" and remove the class "active"
        tablinks_hotel_nhatro[i].className = tablinks_hotel_nhatro[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    //document.getElementById(cityName).style.display = "block";
    tabcontents_hotel_nhatro[this.position].style.display = "block";
    tablinks_hotel_nhatro[this.position].className += " active";
}