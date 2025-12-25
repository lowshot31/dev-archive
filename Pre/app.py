"""
Pre Dairy Company Homepage - FastAPI Application
유기농, 특별함이 아닌 일상이 되다.
"""

from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from pathlib import Path

# App initialization
app = FastAPI(
    title="Pre Dairy Company",
    description="유기농 유제품 전문 기업 홈페이지",
    version="1.0.0"
)

# Get the base directory
BASE_DIR = Path(__file__).resolve().parent

# Mount static files
app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")

# Setup Jinja2 templates
templates = Jinja2Templates(directory=BASE_DIR / "templates")


# ============================================
# Page Routes
# ============================================

@app.get("/", response_class=HTMLResponse)
async def home(request: Request):
    """메인 홈페이지"""
    return templates.TemplateResponse("index.html", {
        "request": request,
        "page_title": "Pre - 유기농, 특별함이 아닌 일상이 되다",
        "active_page": "home"
    })


@app.get("/about", response_class=HTMLResponse)
async def about(request: Request):
    """회사정보 페이지"""
    return templates.TemplateResponse("about.html", {
        "request": request,
        "page_title": "회사정보 - Pre",
        "active_page": "about"
    })


@app.get("/products", response_class=HTMLResponse)
async def products(request: Request):
    """제품소개 페이지"""
    return templates.TemplateResponse("products.html", {
        "request": request,
        "page_title": "제품 소개 - Pre",
        "active_page": "products"
    })


@app.get("/contact", response_class=HTMLResponse)
async def contact(request: Request):
    """견적 문의 페이지 (Salesforce Web-to-Lead)"""
    return templates.TemplateResponse("contact.html", {
        "request": request,
        "page_title": "견적 문의 - Pre",
        "active_page": "contact"
    })


@app.get("/support", response_class=HTMLResponse)
async def support(request: Request):
    """고객 센터 페이지 (Salesforce Web-to-Case)"""
    return templates.TemplateResponse("support.html", {
        "request": request,
        "page_title": "고객 센터 - Pre",
        "active_page": "support"
    })


# ============================================
# Health Check
# ============================================

@app.get("/health")
async def health_check():
    """서버 상태 확인"""
    return {"status": "healthy", "message": "Pre Homepage is running!"}


# ============================================
# Run with: uv run uvicorn app:app --reload --host 0.0.0.0
# ============================================
