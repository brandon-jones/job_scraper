$(document).ready(function() {
  $('.ssr-exapnd-link').on("click", expandSavedSearchResults);
  $('.del-redis-key').on("click", delRedisKey);
  return $('.saved-search-refresh').on("click", refreshSavedSearch);
});

expandSavedSearchResults = function(e) {
  var link = this;
  var table = $('#'+this.dataset.score.replace('.','\\.')+"-table");

  if (table[0].style.display == "none") {
    table.show(200, 'linear');
    link.classList.remove("glyphicon-plus-sign")
    link.classList.add("glyphicon-minus-sign")
  } else {
    table.hide(200, 'linear');
    link.classList.remove("glyphicon-minus-sign")
    link.classList.add("glyphicon-plus-sign")
  }
};

delRedisKey = function(e) {
  e.stopPropagation();
  e.preventDefault();
  var r = confirm("Are you sure you want to delete this?! It can NOT be undone");
  if (r == true) {
    link = this;
    key = this.dataset.key;
    $.ajax({
      type: 'POST',
      url: '/saved_searches/del_redis_key',
      dataType: 'json',
      data: {
        key: key,
      },
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data, textStatus) {
        link.parentElement.parentElement.parentElement.hidden = true;
      }
    });
  }
};

refreshSavedSearch = function(e) {
  e.stopPropagation();
  e.preventDefault();
  var $refreshLink = this;
  animateClass = "glyphicon-refresh-animate";
  $refreshLink.classList.add( animateClass );

  parentUniqueId = $refreshLink.dataset.parentUniqueId;
  score = $refreshLink.dataset.score;
  type = $refreshLink.dataset.type;
  searchResultsId = $refreshLink.dataset.searchResults;

  $.ajax({
    type: 'POST',
    url: '/saved_searches/refresh',
    dataType: 'html',
    data: {
      parent_unique_id: parentUniqueId,
      score: score,
      type: type,
      search_results_id: searchResultsId
    },
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data, textStatus) {
      $refreshLink.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.innerHTML = data;
      $('.ssr-exapnd-link').unbind("click");
      $('.ssr-exapnd-link').on("click", expandSavedSearchResults);
      $('.saved-search-refresh').unbind("click");
      $('.saved-search-refresh').on("click", refreshSavedSearch);
      $('.apply-for-job').unbind("click");
      $('.apply-for-job').on("click", applyForJob);
      fixLocalTime();
      registerAllViews();
      console.log('testing');
    }
  });

  return;
};


