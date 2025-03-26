class SharePaperDTO {
  final bool useEn;
  final String userName;
  final String avatarUrl;
  final int popularity;
  final String publicationEnName;
  final String publicationCover;
  final String enName;
  final String zhName;
  final String enAbstract;
  final String zhAbstract;
  final List<String> authors;
  final String coverDateStart;
  final num impactFactor;
  final int citationNums;
  final String summary;
  final String introduction;

  SharePaperDTO.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        useEn = json['useEn'] ?? false,
        avatarUrl = json['avatarUrl'],
        popularity = json['popularity'],
        publicationEnName = json['publicationEnName'],
        publicationCover = json['publicationCover'] ?? '',
        enName = json['enName'],
        zhName = json['zhName'],
        enAbstract = json['enAbstract'],
        zhAbstract = json['zhAbstract'],
        authors =
            List.from(json['authors'].where((e) => (e as String).isNotEmpty)),
        coverDateStart = json['coverDateStart'],
        impactFactor = json['impactFactor'] ?? 0,
        citationNums = json['citationNums'],
        summary = json['summary'],
        introduction = json['introduction'];
}
