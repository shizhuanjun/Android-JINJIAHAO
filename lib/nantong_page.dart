import 'package:flutter/material.dart';

void main() {
  runApp(const MyHometownApp());
}

class MyHometownApp extends StatelessWidget {
  const MyHometownApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '家乡南通',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A2F),
      ),
      debugShowCheckedModeBanner: false,
      home: const NantongArticlePage(),
    );
  }
}

class NantongArticlePage extends StatefulWidget {
  const NantongArticlePage({Key? key}) : super(key: key);

  @override
  _NantongArticlePageState createState() => _NantongArticlePageState();
}

class _NantongArticlePageState extends State<NantongArticlePage> {
  int _selectedIndex = 0;
  int _currentImageIndex = 0;
  late PageController _pageController;

  final List<String> _categories = ['家乡简介', '旅游景点', '代表美食', '推荐路线'];

  /// 轮播图图片列表（全部使用本地图片）
  /// 请将图片放入 assets/images/ 目录，并按以下命名放置
  final Map<int, List<String>> _carouselImages = {
    0: [
      'assets/nantong_images/nantong.jpg',
      'assets/nantong_images/river.jpg',
    ],
    1: [
      'assets/nantong_images/mountain.jpg',
    ],
    2: [
      'assets/nantong_images/food.jpg',
      'assets/nantong_images/food1.jpg',
    ],
    3: [
      'assets/nantong_images/jiang.jpg',
      'assets/nantong_images/jiang1.jpg',
    ],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // 自动轮播
    Future.delayed(Duration.zero, () {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_currentImageIndex + 1) % _carouselImages[_selectedIndex]!.length,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        ).then((_) {
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              _currentImageIndex =
                  (_currentImageIndex + 1) % _carouselImages[_selectedIndex]!.length;
              _startAutoScroll();
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarouselHeader(),
                _buildCategoryTabs(),
                _buildArticleContent(),
              ],
            ),
          ),
          // 固定在左上角的返回按钮
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselHeader() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentImageIndex = index;
          });
        },
        itemCount: _carouselImages[_selectedIndex]!.length,
        itemBuilder: (context, index) {
          return _buildCarouselImage(_carouselImages[_selectedIndex]![index]);
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(_categories.length, (index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
                _currentImageIndex = 0;
                if (_pageController.hasClients) {
                  _pageController.jumpToPage(0);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E3A2F) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildArticleContent() {
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = _buildIntroArticle();
        break;
      case 1:
        content = _buildAttractionsArticle();
        break;
      case 2:
        content = _buildFoodArticle();
        break;
      case 3:
        content = _buildRouteArticle();
        break;
      default:
        content = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: content,
      ),
    );
  }

  // ==================== 家乡简介 ====================
  Widget _buildIntroArticle() {
    return Column(
      key: const ValueKey('intro'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '中国近代第一城 —— 南通',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        _buildParagraph(
          '南通，江苏省地级市，古称通州、静海，地处长江三角洲北部，东抵黄海，南望长江，拥有“据江海之会、扼南北之喉”的绝佳地理位置。'
              '作为中国首批对外开放的14个沿海城市之一，南通不仅经济发达，更有着极其深厚的江海文化底蕴。',
        ),
        _buildParagraph(
          '提到南通，就不得不提清末状元、近代著名实业家、教育家张謇先生。一百多年前，张謇先生在家乡南通推行“实业救国、教育救国”，'
              '创办了中国第一所师范学校、第一座民间博物苑、第一家纺织学校等一系列开创性事业，凭借一己之力将南通建成了“中国近代第一城”。',
        ),
        _buildParagraph(
          '走在南通的街头，现代都市的繁华与百年前的民国风情交相辉映，展现出这座城市独一无二的历史人文风貌。南通也是一座“博物馆之城”，'
              '环濠河两岸分布着20多座各具特色的博物馆，是全国独一无二的文化景观。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('📍 城市速览'),
        _buildParagraph(
          '• 别称：静海、崇州、崇川\n'
              '• 市花/市树：菊花/桂花\n'
              '• 人口：约775万（2025年）\n'
              '• 面积：8001平方公里\n'
              '• 地位：国家历史文化名城、中国首批沿海开放城市、长三角北翼经济中心',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==================== 旅游景点 ====================
  Widget _buildAttractionsArticle() {
    return Column(
      key: const ValueKey('attractions'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '漫游南通：不可错过的风景',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        _buildSubHeading('1. 濠河风景名胜区 ⭐⭐⭐⭐⭐'),
        _buildParagraph(
          '濠河，作为南通的城市名片，是国内保留最为完整的四条古护城河之一，距今已有千余年历史。濠河水清如镜，蜿蜒迂回，呈葫芦状环抱南通老城区，'
              '被誉为南通城的“翡翠项链”。强烈推荐在傍晚时分乘坐画舫夜游濠河，欣赏两岸的古建筑与现代桥梁在璀璨灯光下的绝美夜景。'
              '沿河还分布着南通博物苑、中国珠算博物馆等20余座博物馆，被赞为“环濠河博物馆群”。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('2. 狼山风景名胜区 ⭐⭐⭐⭐'),
        _buildParagraph(
          '狼山位于南通市南郊，临江而立，海拔106.94米，素有“江海第一山”的美誉。狼山是中国佛教八小名山之首，是大势至菩萨的道场。'
              '山上的广教禅寺始建于唐代，香火鼎盛。登上山顶，凭栏远眺，长江那“星垂平野阔，月涌大江流”的波澜壮阔尽收眼底。\n\n'
              '五山连游路线：狼山—剑山—军山—黄泥山—马鞍山，一日可尽览五山不同的自然与人文景致。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('3. 南通博物苑'),
        _buildParagraph(
          '由张謇于1905年创办，是中国人自己创办的第一座公共博物馆，现已跻身首批国家一级博物馆。博物苑集自然、历史、美术于一体，'
              '占地约7万平方米，南馆、北馆各具特色。张謇故居——濠南别业坐落其间，院中张謇手植的紫藤花开时如梦如幻。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('4. 唐闸古镇'),
        _buildParagraph(
          '唐闸古镇是张謇创办大生纱厂（中国第一家民营纱厂）的所在地，被誉为“中国近代工业遗存第一镇”。青砖黛瓦、运河悠悠、百年厂房，'
              '工业遗存与江南水乡在这里完美融合。傍晚北市街亮起灯笼，小摊、夜市、运河晚风，烟火气十足。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('5. 值得一去的其他好地方'),
        _buildParagraph(
          '• 南通森林野生动物园：华东地区最大的动物园之一，可自驾与鹿、羊驼互动。\n'
              '• 水绘园（如皋）：明末才子冒辟疆与董小宛的隐居地，被誉为“中国第一情侣文化园”。\n'
              '• 洲际绿博园：热带植物、漂流、四季花海，适合全家出游。\n'
              '• 启东黄金海滩：赶海拾贝、看海上日出，感受长江入海口的辽阔。\n'
              '• 滨江公园：沿长江边骑行散步，傍晚欣赏江面夕阳美景。',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==================== 代表美食 ====================
  Widget _buildFoodArticle() {
    return Column(
      key: const ValueKey('food'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '寻味南通：舌尖上的江海风情',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🍽️ 必吃经典'),
        _buildParagraph(
          '• 西亭脆饼：百年老字号，始于光绪初年，选料考究，经28道工序手工精制。成品色泽金黄，每只饼薄而不碎，有十八层层层分明，'
              '当地歌谣说“西亭脆饼十八层，层层分明能照人，上风吃来下风闻，香甜酥脆爱煞人”。\n\n'
              '• 白蒲茶干：始于三百年前，以白皮黄豆为原料，经20多道工序制成，薄如铜钱，色泽棕黄，五香卤制，软韧鲜香，佐茶下酒皆宜。\n\n'
              '• 南黄海四珍（文蛤、紫菜、鳗鱼、竹蛏）：文蛤被誉为“天下第一鲜”，相传早在唐代就已被列为进贡皇室的极品。\n\n'
              '• 狼山鸡：中国著名的特产优良鸡种，清炖砂锅最能体现其鲜嫩清香，是南通人逢年过节招待贵客的压轴大菜。\n\n'
              '• 火饺：类似油炸饺子，外皮酥脆，猪肉馅鲜美爆汁，唐闸新民巷的老店最正宗。\n\n'
              '• 蟹黄包、缸爿饼、嵌桃麻糕：也是地道的南通味道。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🍜 特色小吃推荐'),
        _buildParagraph(
          '• 南通跳面：非遗技艺制作，面条筋道弹牙，汤头鲜美。\n'
              '• 红烧河豚：南通是河豚之乡，红烧河豚鲜美浓郁，胆大才敢吃。\n'
              '• 吕四海蜇、海门羊肉、白汁鮰鱼：均为南通经典江海菜肴。\n'
              '• 火饺、缸爿饼、青团、如皋董糖：街头巷尾随处可见的传统小吃。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🏪 老字号推荐'),
        _buildParagraph(
          '• 四宜糕团店：蟹黄汤包、各式糕团，老南通人的回忆。\n'
              '• 三香斋茶干：白蒲茶干的正宗老字号，非遗传承。\n'
              '• 西亭脆饼总店：百年工艺传承，伴手礼首选。',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==================== 推荐路线 ====================
  Widget _buildRouteArticle() {
    return Column(
      key: const ValueKey('route'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '南通旅行攻略：三种路线随心选',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🗺️ 一日游（主城区精华）'),
        _buildParagraph(
          '【上午】南通博物苑 → 钟楼广场 → 唐闸古镇（工业遗产+老街巷）\n'
              '【下午】狼山风景区（登高俯瞰长江）\n'
              '【傍晚】濠河夜游（乘画舫看灯光秀）→ 四宜糕团店尝蟹黄汤包',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🗺️ 两日游（市区深度+如皋古镇）'),
        _buildParagraph(
          'Day 1：狼山风景区 → 啬园 → 濠河风景区（含夜游）\n'
              'Day 2：如皋水绘园（感受才子佳人故事）→ 如皋定慧寺 → 返程',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🗺️ 三日游（江海全线）'),
        _buildParagraph(
          'Day 1：南通博物苑 → 张謇纪念馆 → 钟楼广场 → 唐闸古镇\n'
              'Day 2：狼山风景区 → 剑山/军山 → 黄泥山（五山连游）\n'
              'Day 3：启东黄金海滩/恒大威尼斯 → 返程',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🚄 交通贴士'),
        _buildParagraph(
          '• 高铁：至南通站（近老城和濠河）或南通西站，上海出发不到1小时。\n'
              '• 飞机：南通兴东国际机场，半小时可达市区。\n'
              '• 市内：地铁1号线、2号线已开通，公交大多2元，打车起步价10元左右。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🏨 住宿建议'),
        _buildParagraph(
          '建议住崇川区，靠近博物苑、濠河、唐闸古镇，吃逛都方便。',
        ),
        const SizedBox(height: 20),
        _buildSubHeading('🎒 最佳时节与伴手礼'),
        _buildParagraph(
          '• 最佳时节：春季看紫藤花海（博物苑紫藤最出名），秋日狼山登高最舒适。\n'
              '• 伴手礼：西亭脆饼、白蒲茶干、蓝印花布文创品。',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==================== 辅助 UI 组件 ====================
  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF4A4A4A), letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildSubHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF1E3A2F)),
      ),
    );
  }

  /// 加载本地图片
  Widget _buildCarouselImage(String assetPath) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade100),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 40, color: Colors.grey.shade500),
                const SizedBox(height: 8),
                Text(
                  '图片加载失败\n$assetPath',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}