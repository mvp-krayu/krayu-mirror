module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("css");
 
  return {
    dir: {
      input: "pages",
      includes: "../_includes",
      data: "../_data",
      output: "_site"
    }
  };
};
