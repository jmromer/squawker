function updateCountdown(){var n=$("#squawk_content").val().length,t=160-n;10>=t?$("#countdown").text(t).css("color","red"):$("#countdown").text(t).css("color","black")}$(document).ready(function(){$("#squawk_content").focus(function(){updateCountdown(),$("#squawk_content").change(updateCountdown),$("#squawk_content").keyup(updateCountdown)})}),$(document).ready(function(){$("#squawk_content").focusout(function(){$("#countdown").text("")})});