import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/shop_models.dart';
import 'shop_items_screen.dart';

class SparePartScreen extends StatefulWidget {
  const SparePartScreen({super.key});

  @override
  State<SparePartScreen> createState() => _SparePartScreenState();
}

class _SparePartScreenState extends State<SparePartScreen> {
  late final List<Shop> _allShops;
  List<Shop> _filteredShops = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allShops = _getSampleShops();
    _filteredShops = _allShops;
    _searchController.addListener(_filterShops);
  }

  void _filterShops() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShops = _allShops.where((shop) {
        return shop.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is the main build method for the screen
    return Scaffold(
      // The background color will be set automatically by the theme from main.dart
      appBar: AppBar(
        title: const Text('Spare Part Shops'),
      ),
      body: Column(
        children: [
          // This calls the one, correct _buildSearchBar method
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _filteredShops.length,
              itemBuilder: (context, index) {
                final shop = _filteredShops[index];
                return _ShopCard(shop: shop);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Builder Widgets are defined inside the State class ---

  Widget _buildSearchBar() {
    // This is the single, correct search bar widget builder
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: TextField(
        controller: _searchController, // This now works correctly
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: 'Search for a shop...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: isDark ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: isDark ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  // Dummy data method is also inside the State class
  List<Shop> _getSampleShops() {
    return [
      Shop(
        id: 'shop1',
        name: 'ALMHAID German Auto Parts',
        address: 'Building 10104 H, 7749 Way, Seeb, Muscat, Oman',
        logoUrl: 'https://lh3.googleusercontent.com/p/AF1QipMXfBGG_au0M-3W5E6_ACnBdZ3Pwp_WuSKDefF0=w408-h725-k-no',
        items: [
          Item(
            name: 'Bosch Front Brake Pads',
            description: 'Premium ceramic brake pads for sedans and SUVs',
            price: 34.00,
            imageUrl: 'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcT_872D5ekMhYngwDixnV4Rlve9PzC_Mv4adv6AuUalrt3e9f5nDZPvIM7GxVT8oRnbjbth1MbQZ5BqNWX9IDxSlCkLxmw-fxtocPiKcM0GU3_2VNtIKg2x9Fta3E_hPjcsP_Zfzl_evA&usqp=CAc',
          ),
          Item(
            name: 'NGK Spark Plugs (Set of 4)',
            description: 'Iridium spark plugs – suitable for many petrol engines',
            price: 22.00,
            imageUrl: 'https://media.bofiracing.com/uploads/2023/02/NGK-Spark-Plugs-for-Mazda-MX-5-NA-NB.jpg',
          ),
          Item(
            name: 'Mahle Engine Air Filter',
            description: 'OEM-level air filter for multiple models',
            price: 18.00,
            imageUrl: 'https://hndautomotiveparts.com/cdn/shop/files/MAH6460940004_135c7a40-02bb-4283-8e97-8df4bfbb7f20.jpg?v=1697546331',
          ),
          Item(
            name: 'MANN Cabin Air Filter',
            description: 'High-efficiency cabin filter for improved air quality',
            price: 15.00,
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTi5rf3kFQz20DWaVkIYGS4itUFiyJsFsKk3g&s',
          ),
          Item(
            name: 'Denso Radiator Fan',
            description: 'Replacement radiator cooling fan assembly',
            price: 68.00,
            imageUrl: 'https://http2.mlstatic.com/D_NQ_NP_763411-CBT45298934103_032021-O.webp',
          ),
          Item(
            name: 'Valeo Alternator',
            description: '12V alternator for mid-size Japanese/Korean vehicles',
            price: 110.00,
            imageUrl: 'https://4.imimg.com/data4/NP/VA/IOS-3902331/product.jpeg',
          ),
          Item(
            name: 'KYB Shock Absorber – Front Pair',
            description: 'Gas-charged front shocks for improved ride comfort',
            price: 74.00,
            imageUrl: 'https://i.ebayimg.com/images/g/dmkAAOSw1~hdfjOL/s-l1200.jpg',
          ),
          Item(
            name: 'Delphi Fuel Pump',
            description: 'High-performance fuel pump for gasoline engines',
            price: 98.00,
            imageUrl: 'https://i.ebayimg.com/images/g/EeoAAOSwSitmVhYn/s-l1200.jpg',
          ),
          Item(
            name: 'Gates Serpentine Belt',
            description: 'OE-equivalent drive belt for multi-accessory engines',
            price: 20.00,
            imageUrl: 'https://www.boefab.com/cdn/shop/products/Gates-Belt-web-800_1024x1024.jpg?v=1444533044',
          ),
          Item(
            name: 'Bosch Oxygen Sensor',
            description: 'O2 sensor for improved fuel economy and emissions',
            price: 54.00,
            imageUrl: 'https://www.justraceparts.com.au/image/cache/catalog/genuine-bosch-17025-replacement-wideband-sensor-1000x1000.jpg',
          ),
        ],
      ),

      Shop(
        id: 'shop2',
        name: 'ARB Oman 4x4 Accessories',
        address: 'Seeb, Muscat',
        logoUrl: 'https://lh3.googleusercontent.com/p/AF1QipMCSNiM8fd1ckjGmhB7C1mNxDypCJ2Ltsm81WXM=s680-w680-h510-rw',
        items: [
          Item(
            name: 'ARB Front Bull Bar',
            description: 'Steel bull bar for Toyota Land Cruiser & Patrol',
            price: 850.00,
            imageUrl: 'https://w24cdn.cz/www.escape4x4.cz/_/1200x800-0-1-0-0/product/product_6196/970aebdb337b2088e0ba55bc070652bc.jpg?5',
          ),
          Item(
            name: 'ARB Old Man Emu Suspension Kit',
            description: 'Heavy-duty suspension for off-road SUVs',
            price: 980.00,
            imageUrl: 'https://megajimny.com/cdn/shop/files/Untitleddesign_5_443a0d82-d331-4fdf-908a-3cf4181f96f2.jpg?v=1696910718&width=650',
          ),
          Item(
            name: 'ARB Air Locker',
            description: 'Differential air locker for 4x4 vehicles',
            price: 620.00,
            imageUrl: 'https://www.roadrunneroffroad.com.au/assets/full/RD152.webp?20241202202513',
          ),
          Item(
            name: 'ARB Twin Air Compressor',
            description: 'High-output on-board air compressor',
            price: 430.00,
            imageUrl: 'https://psp.ae/wp-content/uploads/2019/12/arb.png',
          ),
          Item(
            name: 'Roof Rack System',
            description: 'Heavy-duty ARB roof rack for camping gear',
            price: 395.00,
            imageUrl: 'https://4x4works.b-cdn.net/app/uploads/2020/04/AR-RR-DEL-1.jpg',
          ),
          Item(
            name: 'Safari Snorkel Kit',
            description: 'Raised air intake for water crossings',
            price: 260.00,
            imageUrl: 'https://www.johncraddockltd.co.uk/_images/_images/xl/39568-da3069-safari-raised-air-intake-snorkel-defender-td5puma-1999.jpg',
          ),
          Item(
            name: 'Under Vehicle Protection (Skid Plates)',
            description: 'Protects engine and transmission',
            price: 420.00,
            imageUrl: 'https://nopimagestorage.blob.core.windows.net/images/0055659_arb-under-vehicle-protection-prado-150-wkinetic.jpeg',
          ),
          Item(
            name: 'Recovery D-Shackles (Pair)',
            description: 'Heavy-duty shackles for vehicle recovery',
            price: 22.00,
            imageUrl: 'https://ja4x4.imgix.net/2024/08/ARB-Steel-Bow-Shackle-1.jpg?fit=fit&fm=jpg&h=0&q=45&w=1200&s=5021b0994e4c9017fa6ee25e35124d24',
          ),
        ],
      ),


      Shop(
        id: 'shop3',
        name: 'HYUNDAI AND KIA PARTS SIAL INTERNATIONAL LLC',
        address: 'Seeb, Muscat',
        logoUrl: 'https://lh3.googleusercontent.com/p/AF1QipO2vR8ZEl6e-koioOWidLF60DrF8kapMWkqSa2A=s680-w680-h510-rw',
        items: [
          Item(
            name: 'OEM Hyundai Brake Pads',
            description: 'Front brake pads for Elantra, Sonata',
            price: 38.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71Z9QXv4wVL.jpg',
          ),
          Item(
            name: 'Kia Oil Filter',
            description: 'OEM oil filter – Sportage/Sorento',
            price: 6.50,
            imageUrl: 'https://m.media-amazon.com/images/I/61X5Yc3ZQnL.jpg',
          ),
          Item(
            name: 'Hyundai Ignition Coil',
            description: '1.6L / 2.0L engine OEM coil',
            price: 22.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61D7zZkK0-L.jpg',
          ),
          Item(
            name: 'Kia Engine Air Filter',
            description: 'Genuine cabin/engine air filter',
            price: 12.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71lY3zR7tTL.jpg',
          ),
          Item(
            name: 'Hyundai Genuine Spark Plugs',
            description: 'Set of 4 – OEM plugs',
            price: 19.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61qCIfQtz7L.jpg',
          ),
          Item(
            name: 'Genuine Hyundai Timing Belt',
            description: 'Timing belt for Accent / i10 engines',
            price: 42.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71T1X2eFQML.jpg',
          ),
          Item(
            name: 'Kia Radiator Cap',
            description: 'OEM radiator pressure cap',
            price: 8.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61oYcUo7onL.jpg',
          ),
          Item(
            name: 'Hyundai Fuel Pump',
            description: 'Fuel pump assembly for select models',
            price: 85.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71mPgBP4q-L.jpg',
          ),
        ],
      ),


      Shop(
        id: 'shop4',
        name: 'Gulf National Company LLC',
        address: 'Ghala Sinaiyyah St, Opp. Al Ansari Building, Ghala Industrial Area, Muscat, Oman',
        logoUrl: 'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSwiQT0YIS71Qluqy3YWepA0KPI2MfaGuK-yTiiJK8EHPqlJ9EdYdCxcCGSon97QyVAglW1PZzvp0AmgHI8C7bhXRw49an68rl4aRt1m6txuSbgngifDPQhbrSUUKGsx2bBCcCRN=w243-h174-n-k-no-nu',
        items: [
          Item(
            name: 'Perkins Diesel Engine Gasket Kit',
            description: 'Full gasket set for Perkins diesel engines used in backhoes and heavy equipment',
            price: 220.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61H9G91Rx+L.jpg',
          ),
          Item(
            name: 'JCB Backhoe Loader Engine Filter Set',
            description: 'Complete filter set including air, oil, and fuel filters for JCB backhoes',
            price: 75.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61qk2m2a1HL.jpg',
          ),
          Item(
            name: 'Volvo Excavator Hydraulic Seal Kit',
            description: 'Seal replacement kit for Volvo excavator hydraulic cylinders',
            price: 180.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71bUyZ8YqkL.jpg',
          ),
          Item(
            name: 'Bobcat Loader Engine Oil Filter',
            description: 'OEM-grade oil filter for Bobcat compact loaders',
            price: 28.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61tYzNFS1gL.jpg',
          ),
          Item(
            name: 'Isuzu Heavy Duty Fuel Injection Pump',
            description: 'High-pressure fuel injection pump for Isuzu diesel engines',
            price: 450.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71dUOxiKNML.jpg',
          ),
          Item(
            name: 'Kubota Engine Air Filter Assembly',
            description: 'Replacement air filter element for Kubota engines',
            price: 34.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61xTzkrGd+L.jpg',
          ),
          Item(
            name: 'Perkins Alternator 24V',
            description: 'Heavy-duty alternator for Perkins generator and machinery engines',
            price: 185.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61Z8T4TQG2L.jpg',
          ),
          Item(
            name: 'Transmission Drive Belt for JCB',
            description: 'OEM-standard drive belt used in JCB telehandlers and backhoes',
            price: 36.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61hCZR5K49L.jpg',
          ),
          Item(
            name: 'Volvo Excavator Engine Oil Cooler',
            description: 'Engine oil cooler for select Volvo digging equipment',
            price: 290.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71y917j1d6L.jpg',
          ),
          Item(
            name: 'Starter Motor – Heavy Equipment',
            description: 'High-torque starter motor for construction vehicles and loaders',
            price: 135.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71+6cQByInL.jpg',
          ),
        ],
      ),

      Shop(
        id: 'shop5',
        name: 'Muscat Tyres & Batteries',
        address: 'Ghala, Muscat',
        logoUrl: 'https://lh3.googleusercontent.com/p/AF1QipMrkoymAcGQurcf1LiD5b3stcCL26YOXmZVeTHo=w408-h272-k-no',
        items: [
          Item(
            name: 'Michelin Latitude Tour Tyre – 235/55 R18',
            description: 'Premium SUV touring tyre',
            price: 150.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71M2V5s4QXL.jpg',
          ),
          Item(
            name: 'Hankook Dynapro HP2 Tyre – 255/60 R18',
            description: 'All-season SUV tyre',
            price: 130.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61mJYsx7x9L.jpg',
          ),
          Item(
            name: 'Amaron ProCar Battery – 12V 70Ah',
            description: 'Maintenance-free lead-acid battery',
            price: 65.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61WwQ8rQYTL.jpg',
          ),
          Item(
            name: 'Bosch S4 Battery – 12V 60Ah',
            description: 'High reliability car battery',
            price: 58.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61J5qgOaJkL.jpg',
          ),
          Item(
            name: 'Nitrogen Tyre Inflation',
            description: 'Nitrogen fill per tyre service',
            price: 2.50,
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/75/Nitrogen_tire_inflation.jpg',
          ),
          Item(
            name: 'Wheel Balancing Service',
            description: 'Precision balancing to reduce vibration',
            price: 5.00,
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/3/36/Wheel_balancing_machine.jpg',
          ),
          Item(
            name: 'Wheel Alignment',
            description: 'Front & rear alignment',
            price: 12.00,
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/02/Wheel_alignment_throw.jpg',
          ),
          Item(
            name: 'Tyre Valve Stems (Set of 4)',
            description: 'Replacement tyre valve stems',
            price: 3.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61u1MHtgCwL.jpg',
          ),
          Item(
            name: 'Portable Jump Starter Kit',
            description: 'Emergency jump start power pack',
            price: 35.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61cJ+dT3WHL.jpg',
          ),
          Item(
            name: 'Wheel Nut Set (20pcs)',
            description: 'Steel wheel nuts for common rims',
            price: 8.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61YxBr4QjkL.jpg',
          ),
        ],
      ),



      Shop(
        id: 'shop6',
        name: 'Sial Kingdom Trading LLC',
        address: 'Mabela Sanaiya, Seeb, Muscat',
        logoUrl: 'https://lh3.googleusercontent.com/p/AF1QipPKxIAnm31rGBV1d4mo6lJwtJMyHsaCx-Chvt-B=w243-h174-n-k-no-nu',
        items: [
          Item(
            name: 'Bosch Front Brake Discs (Pair)',
            description: 'Ventilated brake discs for Toyota & Nissan sedans',
            price: 52.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71FfwRyk6mL.jpg',
          ),
          Item(
            name: 'Front Brake Pads – Ceramic',
            description: 'Low-noise ceramic pads for Japanese vehicles',
            price: 34.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61J8HYNAGTL.jpg',
          ),
          Item(
            name: 'Wheel Bearing Kit',
            description: 'Front wheel bearing kit with hub',
            price: 38.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71zf6p88eQL.jpg',
          ),
          Item(
            name: 'Lower Control Arm',
            description: 'Suspension control arm for Toyota Camry / Altima',
            price: 55.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61uY9uN2YML.jpg',
          ),
          Item(
            name: 'Tie Rod End',
            description: 'Outer tie rod end for steering systems',
            price: 14.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61Z4Z6y+vDL.jpg',
          ),
          Item(
            name: 'Shock Absorber – Front',
            description: 'Gas-filled front shock absorber',
            price: 48.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71oD9fhMnjL.jpg',
          ),
          Item(
            name: 'Radiator Cooling Fan',
            description: 'Electric cooling fan assembly',
            price: 65.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71t6Z0ZzqPL.jpg',
          ),
          Item(
            name: 'Engine Thermostat',
            description: 'Cooling system thermostat (82°C)',
            price: 16.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61XIFcZ5LTL.jpg',
          ),
          Item(
            name: 'Fuel Filter',
            description: 'In-line fuel filter for petrol engines',
            price: 9.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61M9gFUnGSL.jpg',
          ),
          Item(
            name: 'Automatic Transmission Filter',
            description: 'Transmission oil filter for Japanese cars',
            price: 22.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61XwD8lq2ZL.jpg',
          ),
          Item(
            name: 'Drive Shaft (CV Axle)',
            description: 'Complete CV axle assembly – front',
            price: 78.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71z+0g0ZpRL.jpg',
          ),
          Item(
            name: 'Engine Oil – 5W-30 (4L)',
            description: 'Fully synthetic engine oil',
            price: 21.00,
            imageUrl: 'https://m.media-amazon.com/images/I/71h7t8Kp6nL.jpg',
          ),
          Item(
            name: 'Power Steering Pump',
            description: 'Hydraulic power steering pump',
            price: 95.00,
            imageUrl: 'https://m.media-amazon.com/images/I/61zH0vW4VXL.jpg',
          ),
        ],
      ),



    ];
  }
} // This curly brace closes the _SparePartScreenState class

// --- The _ShopCard Widget is separate and self-contained ---

class _ShopCard extends StatelessWidget {
  final Shop shop;
  const _ShopCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 4 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShopItemsScreen(shop: shop)),
        ),
        child: SizedBox(
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                shop.logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) { // Added error builder for robustness
                  return const Icon(Icons.store, color: Colors.grey, size: 60);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )
                      : LinearGradient(
                    colors: [Colors.white.withOpacity(0.8), Colors.transparent],
                    stops: const [0.0, 0.7],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 2, // Allow text to wrap
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 20, // Adjusted font size slightly
                        shadows: [
                          Shadow(
                              blurRadius: 2.0,
                              color: isDark ? Colors.black87 : Colors.white,
                              offset: const Offset(1, 1))
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: isDark ? Colors.white70 : Colors.black54,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded( // Allow address to take available space and wrap if needed
                          child: Text(
                            shop.address,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Icon(Icons.arrow_forward_ios,
                    color: isDark ? Colors.white70 : Colors.black54, size: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
