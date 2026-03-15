module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("css");
  eleventyConfig.addPassthroughCopy({ "static": "." });
 
  return {
    dir: {
      input: "pages",
      includes: "../_includes",
      data: "../_data",
      output: "_site"
    }
  };
};
