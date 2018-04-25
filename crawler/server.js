//Khởi tạo driver kết nối tới Selenium hub
const {Builder, until} = require('selenium-webdriver');

const fs = require('fs');
let driver = new Builder()
    .forBrowser('firefox')
    .usingServer(process.env.SELENIUM_REMOTE_URL || 'http://localhost:4444/wd/hub')
    .build();

//Url cần lấy thông tin các hotel
const hotel_url = "https://www.traveloka.com/vi-vn/hotel/search?spec=26-04-2018.27-04-2018.1.1.HOTEL_GEO.10009843.Ha%20Noi%20City.1";

//Thực hiện tải trang
driver.get(hotel_url)
    .then(() => driver.wait(until.titleIs("Khách sạn ở Hà Nội từ 26-Apr-2018 đến 27-Apr-2018")))
    .then(() => driver.getTitle())
    .then((title) => {
        console.log(title);
    })
    .then(() => {
        driver.quit();
    });