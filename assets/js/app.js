(function() {
  let select = document.getElementById('order_event_id');

  if(select) {
    select.onchange = function() {
      window.location = window.location.origin + window.location.pathname + '?event_id=' + select.value
    }

  }
})()
