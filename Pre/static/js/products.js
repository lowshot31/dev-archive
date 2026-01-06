/**
 * Pre Dairy Products Data Management
 * 제품 데이터를 동적으로 관리하고 렌더링합니다.
 */

// 제품 데이터 배열
const productsData = [
    // 유기농 우유
    { id: 'ML-001', name: '유기농 우유 200ML', category: 'organic', description: '100% 유기농 원유로 만든 순수한 맛', badge: 'BEST' },
    { id: 'ML-002', name: '유기농 초코 우유 200ML', category: 'organic', description: '진한 초콜릿과 유기농 우유의 만남', badge: 'HOT' },
    { id: 'ML-003', name: '유기농 딸기 우유 200ML', category: 'organic', description: '상큼한 딸기향이 가득한 우유', badge: null },
    { id: 'ML-004', name: '유기농 바나나 우유 200ML', category: 'organic', description: '달콤한 바나나 풍미의 건강한 우유', badge: null },
    { id: 'ML-005', name: '유기농 메론 우유 200ML', category: 'organic', description: '시원한 메론향의 프리미엄 우유', badge: null },
    { id: 'ML-006', name: '유기농 무가당 초코 우유 200ML', category: 'organic', description: '설탕 없이 즐기는 초콜릿 우유', badge: null },
    { id: 'ML-007', name: '유기농 무가당 딸기 우유 200ML', category: 'organic', description: '설탕 없이 즐기는 딸기 우유', badge: null },
    { id: 'ML-008', name: '유기농 무가당 바나나 우유 200ML', category: 'organic', description: '설탕 없이 즐기는 바나나 우유', badge: null },
    { id: 'ML-009', name: '유기농 무가당 메론 우유 200ML', category: 'organic', description: '설탕 없이 즐기는 메론 우유', badge: null },

    // 저지방 2%
    { id: 'ML-010', name: '저지방 2% 우유 200ML', category: 'lowfat', categoryLabel: '저지방 2%', description: '가벼움과 영양을 동시에', badge: 'BEST' },
    { id: 'ML-011', name: '저지방 2% 초코 우유 200ML', category: 'lowfat', categoryLabel: '저지방 2%', description: '가벼운 초콜릿 우유', badge: null },
    { id: 'ML-012', name: '저지방 2% 딸기 우유 200ML', category: 'lowfat', categoryLabel: '저지방 2%', description: '가벼운 딸기 우유', badge: null },
    { id: 'ML-013', name: '저지방 2% 바나나 우유 200ML', category: 'lowfat', categoryLabel: '저지방 2%', description: '가벼운 바나나 우유', badge: null },
    { id: 'ML-014', name: '저지방 2% 메론 우유 200ML', category: 'lowfat', categoryLabel: '저지방 2%', description: '가벼운 메론 우유', badge: null },

    // 저지방 1%
    { id: 'ML-015', name: '저지방 1% 우유 200ML', category: 'lowfat', categoryLabel: '저지방 1%', description: '더욱 가벼운 건강한 선택', badge: 'HOT' },
    { id: 'ML-016', name: '저지방 1% 초코 우유 200ML', category: 'lowfat', categoryLabel: '저지방 1%', description: '더욱 가벼운 초콜릿 우유', badge: null },
    { id: 'ML-017', name: '저지방 1% 딸기 우유 200ML', category: 'lowfat', categoryLabel: '저지방 1%', description: '더욱 가벼운 딸기 우유', badge: null },
    { id: 'ML-018', name: '저지방 1% 바나나 우유 200ML', category: 'lowfat', categoryLabel: '저지방 1%', description: '더욱 가벼운 바나나 우유', badge: null },
    { id: 'ML-019', name: '저지방 1% 메론 우유 200ML', category: 'lowfat', categoryLabel: '저지방 1%', description: '더욱 가벼운 메론 우유', badge: null },

    // 무지방 0%
    { id: 'ML-020', name: '무지방 0% 우유 200ML', category: 'lowfat', categoryLabel: '무지방 0%', description: '지방 없이 순수한 우유의 맛', badge: null },
    { id: 'ML-021', name: '무지방 0% 초코 우유 200ML', category: 'lowfat', categoryLabel: '무지방 0%', description: '지방 없는 초콜릿 우유', badge: null },
    { id: 'ML-022', name: '무지방 0% 딸기 우유 200ML', category: 'lowfat', categoryLabel: '무지방 0%', description: '지방 없는 딸기 우유', badge: null },
    { id: 'ML-023', name: '무지방 0% 바나나 우유 200ML', category: 'lowfat', categoryLabel: '무지방 0%', description: '지방 없는 바나나 우유', badge: null },
    { id: 'ML-024', name: '무지방 0% 메론 우유 200ML', category: 'lowfat', categoryLabel: '무지방 0%', description: '지방 없는 메론 우유', badge: null },

    // 락토프리
    { id: 'ML-025', name: '락토프리 우유 200ML', category: 'lactofree', description: '유당 불내증도 안심하고 즐기세요', badge: 'BEST' },
    { id: 'ML-026', name: '락토프리 초코 우유 200ML', category: 'lactofree', description: '편안하게 즐기는 초코 우유', badge: 'HOT' },
    { id: 'ML-027', name: '락토프리 딸기 우유 200ML', category: 'lactofree', description: '편안하게 즐기는 딸기 우유', badge: null },
    { id: 'ML-028', name: '락토프리 바나나 우유 200ML', category: 'lactofree', description: '편안하게 즐기는 바나나 우유', badge: null },
    { id: 'ML-029', name: '락토프리 메론 우유 200ML', category: 'lactofree', description: '편안하게 즐기는 메론 우유', badge: null },
    { id: 'ML-030', name: '락토프리 저지방 & 프리바이오틱스', category: 'lactofree', description: '장 건강까지 생각한 기능성 우유', badge: null },
    { id: 'ML-031', name: '락토프리 저지방 & 프리바이오틱스 초코', category: 'lactofree', description: '장 건강과 초콜릿 맛의 조화', badge: null },
    { id: 'ML-032', name: '락토프리 저지방 & 프리바이오틱스 딸기', category: 'lactofree', description: '장 건강과 딸기 맛의 조화', badge: null },
    { id: 'ML-033', name: '락토프리 저지방 & 프리바이오틱스 바나나', category: 'lactofree', description: '장 건강과 바나나 맛의 조화', badge: null },
    { id: 'ML-034', name: '락토프리 저지방 & 프리바이오틱스 메론', category: 'lactofree', description: '장 건강과 메론 맛의 조화', badge: null },
    { id: 'ML-035', name: '락토프리 단백질 우유 200ML', category: 'lactofree', description: '운동 후 완벽한 단백질 보충', badge: null },
    { id: 'ML-036', name: '락토프리 단백질 초코 우유 200ML', category: 'lactofree', description: '단백질과 초콜릿의 완벽한 조합', badge: null },
    { id: 'ML-037', name: '락토프리 단백질 딸기 우유 200ML', category: 'lactofree', description: '단백질과 딸기의 완벽한 조합', badge: null },
    { id: 'ML-038', name: '락토프리 단백질 바나나 우유 200ML', category: 'lactofree', description: '단백질과 바나나의 완벽한 조합', badge: null },
    { id: 'ML-039', name: '락토프리 단백질 메론 우유 200ML', category: 'lactofree', description: '단백질과 메론의 완벽한 조합', badge: null },

    // 프리미엄
    { id: 'ML-040', name: '프리미엄 우유 200ML', category: 'premium', description: '엄선된 젖소에서 얻은 최고급 우유', badge: 'BEST' },
    { id: 'ML-041', name: '프리미엄 초코 우유 200ML', category: 'premium', description: '프리미엄 원유와 고급 초콜릿의 조화', badge: 'HOT' },
    { id: 'ML-042', name: '프리미엄 딸기 우유 200ML', category: 'premium', description: '신선한 딸기와 프리미엄 우유', badge: null },
    { id: 'ML-043', name: '프리미엄 바나나 우유 200ML', category: 'premium', description: '달콤한 바나나와 프리미엄 우유', badge: null },
    { id: 'ML-044', name: '프리미엄 메론 우유 200ML', category: 'premium', description: '시원한 메론과 프리미엄 우유', badge: null },

    // 치즈 & 버터
    { id: 'CZ-001', name: '모짜렐라 치즈', category: 'other', categoryLabel: '치즈', description: '쫄깃한 식감의 프리미엄 치즈', badge: 'BEST' },
    { id: 'BT-001', name: '무염 버터', category: 'other', categoryLabel: '버터', description: '신선한 원유로 만든 고소한 버터', badge: null }
];

// 카테고리 정보
const categoryInfo = {
    organic: { name: '유기농', badge: null },
    lowfat: { name: '저지방', badge: 'HOT' },
    lactofree: { name: '락토프리', badge: 'BEST' },
    premium: { name: '프리미엄', badge: 'HOT' },
    other: { name: '치즈 & 버터', badge: null }
};

// 파일명 매핑 (ID -> 실제 파일명)
const imageFileNames = {
    'ML-001': 'ML-001_유기농 우유 200ML.png',
    'ML-002': 'ML-002_유기농 우유 초코맛 200ML.png',
    'ML-003': 'ML-003_유기농 우유 딸기맛 200ML.png',
    'ML-004': 'ML-004_유기농 우유 바나나 200ML.png',
    'ML-005': 'ML-005_유기농 우유 메론맛 200ML.png',
    'ML-006': 'ML-006_유기농 우유 무가당 초코 200ml.png',
    'ML-007': 'ML-007_유기농 우유 무가당 딸기 200ml.png',
    'ML-008': 'ML-008_유기농 우유 무가당 바나나 200ml.png',
    'ML-009': 'ML-009_유기농 우유 무가당 메론맛 200ml.png',
    'ML-010': 'ML-010_저지방 2%_200ml.png',
    'ML-011': 'ML-011_저지방 2%_초코_200ml.png',
    'ML-012': 'ML-012_저지방 2%_딸기_200ml.png',
    'ML-013': 'ML-013_저지방 2%_바나나_200ml.png',
    'ML-014': 'ML-014_저지방 2%_메론_200ml.png',
    'ML-015': 'ML-015_저지방 1%_200ml.png',
    'ML-016': 'ML-016_저지방 1%_초코_200ml.png',
    'ML-017': 'ML-017_저지방 1%_딸기_200ml.png',
    'ML-018': 'ML-018_저지방 1%_바나나_200ml.png',
    'ML-019': 'ML-019_저지방 1%_메론_200ml.png',
    'ML-020': 'ML-020_무지방 0%_200ml.png',
    'ML-021': 'ML-021_무지방 0%_초코_200ml.png',
    'ML-022': 'ML-022_무지방 0%_딸기_200ml.png',
    'ML-023': 'ML-023_무지방 0%_바나나_200ml.png',
    'ML-024': 'ML-024_무지방 0%_메론_200ml.png',
    'ML-025': 'ML-025_락토프리_200ml.png',
    'ML-026': 'ML-026_락토프리_초코_200ml.png',
    'ML-027': 'ML-027_락토프리_딸기_200ml.png',
    'ML-028': 'ML-028_락토프리_바나나_200ml.png',
    'ML-029': 'ML-029_락토프리_메론_200ml.png',
    'ML-030': 'ML-030_락토프리 저지방 & 프리바이오틱스_200ml.png',
    'ML-031': 'ML-031_락토프리 저지방 & 프리바이오틱스_초코_200ml.png',
    'ML-032': 'ML-032_락토프리 저지방 & 프리바이오틱스_딸기_200ml.png',
    'ML-033': 'ML-033_락토프리 저지방 & 프리바이오틱스_바나나_200ml.png',
    'ML-034': 'ML-034_락토프리 저지방 & 프리바이오틱스_메론_200ml.png',
    'ML-035': 'ML-035_락토프리 단백질_200ml.png',
    'ML-036': 'ML-036_락토프리 단백질_초코_200ml.png',
    'ML-037': 'ML-037_락토프리 단백질_딸기_200ml.png',
    'ML-038': 'ML-038_락토프리 단백질_바나나_200ml.png',
    'ML-039': 'ML-039_락토프리 단백질_메론_200ml.png',
    'ML-040': 'ML-040_프리미엄 우유_200ml.png',
    'ML-041': 'ML-041_프리미엄 우유_초코_200ml.png',
    'ML-042': 'ML-042_프리미엄 우유_딸기_200ml.png',
    'ML-043': 'ML-043_프리미엄 우유_바나나_200ml.png',
    'ML-044': 'ML-044_프리미엄 우유_메론_200ml.png',
    'CZ-001': 'CZ-001_모짜렐라 치즈.png',
    'BT-001': 'BT-001_무염 버터.png'
};

/**
 * 제품 카드 HTML 생성
 */
function createProductCard(product) {
    const fileName = imageFileNames[product.id];
    // 현재 페이지의 프로토콜과 호스트를 사용하여 절대 URL 생성
    // 파일명을 URL 인코딩하여 한글, 공백, 특수문자 처리
    const baseUrl = window.location.origin;
    const encodedFileName = encodeURIComponent(fileName);
    const imagePath = `${baseUrl}/static/img/product/${encodedFileName}`;
    const categoryLabel = product.categoryLabel || categoryInfo[product.category].name;
    
    const badgeHTML = product.badge 
        ? `<span class="product-badge">${product.badge}</span>` 
        : '';

    return `
        <div class="product-card" data-category="${product.category}">
            <div class="product-image">
                ${badgeHTML}
                <img src="${imagePath}" 
                     alt="${product.name}" 
                     loading="lazy"
                     onerror="console.error('Failed to load image:', this.src)">
            </div>
            <div class="product-info">
                <span class="product-category">${categoryLabel}</span>
                <h3 class="product-name">${product.name}</h3>
                <p class="product-description">${product.description}</p>
            </div>
        </div>
    `;
}

/**
 * 제품 그리드 렌더링
 */
function renderProducts(filter = 'all') {
    const productGrid = document.getElementById('productGrid');
    if (!productGrid) return;

    let filteredProducts = productsData;
    
    if (filter !== 'all') {
        filteredProducts = productsData.filter(product => product.category === filter);
    }

    productGrid.innerHTML = filteredProducts.map(product => createProductCard(product)).join('');
}

/**
 * 카테고리 필터 버튼 설정
 */
function setupCategoryFilters() {
    const filterButtons = document.querySelectorAll('.category-btn');
    
    filterButtons.forEach(button => {
        button.addEventListener('click', () => {
            // 활성 버튼 스타일 변경
            filterButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // 제품 필터링
            const filter = button.getAttribute('data-filter');
            renderProducts(filter);
        });
    });
}

/**
 * 카테고리 필터 버튼에 배지 추가
 */
function addCategoryBadges() {
    const filterButtons = document.querySelectorAll('.category-btn');
    
    filterButtons.forEach(button => {
        const filter = button.getAttribute('data-filter');
        if (filter !== 'all' && categoryInfo[filter] && categoryInfo[filter].badge) {
            const badge = document.createElement('span');
            badge.className = 'category-badge';
            badge.textContent = categoryInfo[filter].badge;
            button.appendChild(badge);
        }
    });
}

/**
 * 페이지 로드 시 초기화
 */
document.addEventListener('DOMContentLoaded', () => {
    renderProducts('all');
    setupCategoryFilters();
    addCategoryBadges();
});
