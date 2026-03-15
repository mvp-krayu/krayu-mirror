module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("css");
  eleventyConfig.addPassthroughCopy("googleda0de482ef5fac0d.html");
  return {
    dir: {
      input: "pages",
      includes: "../_includes",
      data: "../_data",
      output: "_site"
    }
  };
};
