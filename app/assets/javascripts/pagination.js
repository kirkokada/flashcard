$(function() {
	$('.pagination a').attr('data-remote', 'true');
	$(".pagination a").live("click", function() {
		$(".pagination").html("Loading...");
		$.getScript(this.href);
		return false;
	});
});