window.ItemCollectionView = Backbone.View.extend({ //model:ItemCollection
  settings:{
    cols: 4,
    admin: false
  },
	tagName: "div",
  className: "items-container",
  initialize: function(){
    this.model.bind('change',this.render,this);
    this.model.bind('reset',this.render,this);
  },
  render: function(){
    var self = this;
    $.extend(self.settings,self.options.settings);
    var models = this.model.models;
    var total = models.length;
    if(total > 0){ 
      var rows = parseInt(total / this.settings.cols);
      var extraCols = total % this.settings.cols; 
      for(var i=0;i<rows;i++){
        this.$el.append(this.rowRender(i));
      }
      if(extraCols > 0){
        this.$el.append(this.lastRowRender());
      }
    }
    return this.el;
  },
  rowRender: function(r){
    var start = r*this.settings.cols;
    var end = (r+1)*this.settings.cols;
    var $row = this.rowViewRender(start,end);
    return $row.addClass('row-fluid');
  },
  lastRowRender: function(){
    var total = this.model.models.length;
    var end = total;
    var start = end - total % this.settings.cols;
    var $row = this.rowViewRender(start,end);
    return $row.addClass('row-fluid');
  },
  rowViewRender: function(start,end){
    models = this.model.models;
    var $row = $("<div></div>");
    for(var i=start;i<end;i++){
      var $span = $("<div></div>")
          .addClass('span'+(12/this.settings.cols).toString());
      //console.log(models[i].toJSON());
      var itemView = new ItemView({model:models[i],
                                   settings: this.settings
                                  });
      $row.append($span.html(itemView.render()));
    }
    return $row;
  }
})