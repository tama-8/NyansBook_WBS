// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Import Rails UJS, Turbolinks, ActiveStorage, and Turbo
import Rails from "@rails/ujs"
 import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Import Turbo
// import { Turbo } from "@hotwired/turbo-rails"

// Import jQuery and Bootstrap
import jQuery from "jquery"
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

// Start Rails UJS, Turbolinks, and ActiveStorage
Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Start Turbo (automatically started when imported)
//Turbo.start()

// Make jQuery globally available
global.$ = jQuery;
window.$ = jQuery;
//ハンバーガーメニューのトグルを実装
document.addEventListener("DOMContentLoaded", function() {
    document.querySelector('.navbar-toggler').addEventListener('click', function(event) {
        event.stopPropagation(); // イベントバブリングを防ぐ
        var menu = document.querySelector('.collapse.navbar-collapse');
        if (menu.classList.contains('show')) {
            menu.classList.remove('show');
        } else {
            menu.classList.add('show');
        }
    });

    // メニュー外をクリックしたときにメニューを閉じる処理を追加
    document.addEventListener('click', function(event) {
        var menu = document.querySelector('.collapse.navbar-collapse');
        var toggler = document.querySelector('.navbar-toggler');

        if (!menu.contains(event.target) && !toggler.contains(event.target)) {
            menu.classList.remove('show');
        }
    });
});