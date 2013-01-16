$(document).ready(function() {
    
    // check placeholder browser support
    $.Placeholder.init({ color : "#aaa" });
    
    //slider
    $('#slider').anythingSlider({
        autoPlay : true,
        delay : 3000,
        animationTime : 600,
        startText: "",
        stopText: ""
    });
    
});


