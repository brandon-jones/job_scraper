$(document).ready(function() {
  return registerAllViews();
});

registerAllViews = function(e) {
  rows = $('.never-viewed');
  jQuery.each(rows, function(index, value) {
    values = [];
    values.push(value);
    return $.ajax({
      type: 'POST',
      url: '/saved_searches/viewed',
      dataType: 'json',
      data: {
        parent_unqiue_id: value.dataset.parentUnqiueId,
        score: value.dataset.score
      },
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data, textStatus) {
        console.log('');
      }
    });
  });
};