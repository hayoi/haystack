class Page {
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;

  Page(
      {this.totalCount = 0,
      this.pageSize = 30,
      this.totalPage = 1,
      this.currPage = 0});
}