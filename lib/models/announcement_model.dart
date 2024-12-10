class Announcementmodel {
  final String id;
  final String imgUrl;

  Announcementmodel({required this.id, required this.imgUrl});
}

List<Announcementmodel> dummyAnnouncements = [
  Announcementmodel(
    id: '1',
    imgUrl:
        'https://i.pinimg.com/736x/62/d2/a3/62d2a3405d099d1b1f63f85474e97c49.jpg',
  ),
  Announcementmodel(
    id: '2',
    imgUrl:
        'https://i.pinimg.com/736x/e4/76/61/e47661e9d11e76f53c962ce4aff08db1.jpg',
  ),
  Announcementmodel(
    id: '3',
    imgUrl:
        'https://i.pinimg.com/736x/6b/be/22/6bbe22717871a1aabdab0cb12482b400.jpg',
  ),
  Announcementmodel(
    id: '3',
    imgUrl:
        'https://i.pinimg.com/736x/96/3c/ea/963cea970c852b05edf6ddd18406f780.jpg',
  ),
];
