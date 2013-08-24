// Load the application once the DOM is ready, using `jQuery.ready`:
$(function(){

  // User Model
  // ----------

  // Our basic **User** model has an `email` attribute.
  window.User = Backbone.Model.extend({
	  idAttribute: "_id",
    url: "/api/users",

    // Default attributes for a todo item.
    defaults: function() {
      return {};
    },

    signup: function(user) {
      this.save(user);
    }
  });

  // The Application
  // ---------------

  // Our overall **AppView** is the top-level piece of UI.
  window.AppView = Backbone.View.extend({

    // Instead of generating a new element, bind to the existing skeleton in the HTML

    el: $("#landa"),

    // Delegated events for creating new entries

    events: {
      "keydown #email"        : "showDisclaimer",
      "click #signup_submit"  : "signup"
    },

    // At initialization we bind to the relevant events

    initialize: function() {
      this.input = this.$("#email");
    },

    render: function() {},

    signup: function(e) {
      var text = this.input.val();
      if (!text) return;
      var user = new User;
      user.signup({email: text});
      this.input.val('');
    },

    // Lazily show or hide the disclaimer

    showDisclaimer: function(e) {
      var tooltip = this.$(".disclaimer");
      if (this.tooltipTimeout) clearTimeout(this.tooltipTimeout);

      var val = this.input.val();
      if (val == '' || val == this.input.attr('placeholder')) {
        tooltip.hide();
      } else {
        var show = function() { tooltip.show().fadeIn(); };
        this.tooltipTimeout = _.delay(show, 1000);
      }
    }

  });

  // Finally, we kick things off by creating the **App**.
  window.App = new AppView;
});
