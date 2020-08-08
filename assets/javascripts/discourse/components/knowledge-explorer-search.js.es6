import debounce from "discourse/lib/debounce";

export default Ember.Component.extend({
  classNames: "chord-directory-search",

  debouncedSearch: debounce(function(term) {
    this.onSearch(term);
  }, 500),

  actions: {
    onSearchTermChange(term) {
      this.debouncedSearch(term);
    }
  }
});
