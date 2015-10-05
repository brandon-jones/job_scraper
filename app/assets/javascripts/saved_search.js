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
        link.parentElement.hidden = true;
      }
    });
  }
};




refreshSavedSearch = function(e) {
  e.stopPropagation();
  e.preventDefault();
  refreshLink = this;
  refreshLink.classList.add('glyphicon-refresh-animate')

  parent_unique_id = refreshLink.dataset.parentUniqueId;
  score = refreshLink.dataset.score;

  $.ajax({
    type: 'POST',
    url: '/saved_searches/refresh',
    dataType: 'json',
    data: {
      parent_unique_id: parent_unique_id,
      score: score
    },
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data, textStatus) {
      console.log('testing');
    }
  });

  return refreshLink.classList.remove('glyphicon-refresh-animate');
};


