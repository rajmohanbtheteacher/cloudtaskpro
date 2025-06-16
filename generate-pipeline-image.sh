#!/bin/bash

# Generate Beautiful CI/CD Pipeline Images
# This script helps create stunning visualizations of your CI/CD pipeline

echo "🎨 CloudTaskPro CI/CD Pipeline Image Generator"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Available Methods to Create Beautiful Pipeline Images:${NC}"
echo ""

echo "1. 🌐 Online Mermaid Live Editor (Recommended)"
echo "   - Visit: https://mermaid.live/"
echo "   - Copy the content from 'pipeline-diagram.mmd'"
echo "   - Customize colors and styling"
echo "   - Export as PNG/SVG in high resolution"
echo ""

echo "2. 📱 Mermaid CLI (Command Line)"
echo "   - Install: npm install -g @mermaid-js/mermaid-cli"
echo "   - Generate PNG: mmdc -i pipeline-diagram.mmd -o pipeline.png"
echo "   - High-res: mmdc -i pipeline-diagram.mmd -o pipeline-4k.png -w 3840 -H 2160"
echo ""

echo "3. 🎨 Draw.io / Diagrams.net"
echo "   - Visit: https://app.diagrams.net/"
echo "   - Import Mermaid or create custom flowchart"
echo "   - Add professional styling and colors"
echo "   - Export as PNG/PDF/SVG"
echo ""

echo "4. 🖼️ Canva Infographic Style"
echo "   - Visit: https://www.canva.com/"
echo "   - Search for 'Process Flow' or 'DevOps' templates"
echo "   - Create professional infographic-style pipeline"
echo "   - Add your company branding"
echo ""

echo "5. 💻 VS Code Extension"
echo "   - Install 'Mermaid Preview' extension"
echo "   - Open pipeline-diagram.mmd"
echo "   - Preview and export as image"
echo ""

# Check if mermaid-cli is installed
if command -v mmdc >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Mermaid CLI is installed! Generating images...${NC}"
    echo ""
    
    # Generate different versions
    echo "📸 Generating standard resolution image..."
    mmdc -i pipeline-diagram.mmd -o pipeline-standard.png -w 1920 -H 1080 --backgroundColor white --theme default
    
    echo "📸 Generating high resolution image..."
    mmdc -i pipeline-diagram.mmd -o pipeline-hires.png -w 3840 -H 2160 --backgroundColor white --theme default
    
    echo "📸 Generating dark theme image..."
    mmdc -i pipeline-diagram.mmd -o pipeline-dark.png -w 1920 -H 1080 --backgroundColor "#1a1a1a" --theme dark
    
    echo "📸 Generating SVG vector image..."
    mmdc -i pipeline-diagram.mmd -o pipeline-vector.svg --backgroundColor white --theme default
    
    echo -e "${GREEN}✅ Images generated successfully!${NC}"
    echo ""
    echo "📂 Generated files:"
    ls -la pipeline-*.png pipeline-*.svg 2>/dev/null || echo "No image files found"
    
else
    echo -e "${YELLOW}⚠️  Mermaid CLI not installed. Install it with:${NC}"
    echo "   npm install -g @mermaid-js/mermaid-cli"
    echo ""
fi

echo -e "${BLUE}🎯 Pro Tips for Beautiful Pipeline Images:${NC}"
echo ""
echo "🎨 Color Schemes:"
echo "   - Professional: Blues, grays, and green accents"
echo "   - Modern: Gradients with purple and teal"
echo "   - Corporate: Company brand colors"
echo ""
echo "📐 Layout Tips:"
echo "   - Use consistent spacing between elements"
echo "   - Group related stages with similar colors"
echo "   - Add icons and emojis for visual appeal"
echo "   - Include metrics and status indicators"
echo ""
echo "🖼️ Export Settings:"
echo "   - PNG: 300 DPI for print quality"
echo "   - SVG: Vector format for scalability"
echo "   - High resolution: 4K (3840x2160) for presentations"
echo ""

# Create a custom CSS theme file
echo "🎨 Creating custom theme file..."
cat > pipeline-theme.css << 'EOF'
/* Custom CloudTaskPro CI/CD Pipeline Theme */
.node rect,
.node circle,
.node ellipse,
.node polygon {
    fill: #f9f9f9;
    stroke: #333;
    stroke-width: 2px;
}

.node.startNode rect {
    fill: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    stroke: #5a67d8;
    stroke-width: 3px;
}

.node.endNode rect {
    fill: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
    stroke: #38a169;
    stroke-width: 3px;
}

.node.testNode rect {
    fill: linear-gradient(135deg, #fc466b 0%, #3f5efb 100%);
    stroke: #e53e3e;
    stroke-width: 2px;
}

.node.buildNode rect {
    fill: linear-gradient(135deg, #fdbb2d 0%, #22c1c3 100%);
    stroke: #ed8936;
    stroke-width: 2px;
}

.edgePath path {
    stroke: #4a5568;
    stroke-width: 2px;
    fill: none;
}

.arrowheadPath {
    fill: #4a5568;
    stroke: #4a5568;
}

/* Title styling */
.titleBox {
    fill: #2d3748;
    stroke: #4a5568;
    stroke-width: 2px;
    rx: 5px;
}

.titleText {
    fill: white;
    font-size: 16px;
    font-weight: bold;
}
EOF

echo "✅ Custom theme created: pipeline-theme.css"
echo ""

echo -e "${GREEN}🎉 Ready to Create Beautiful Pipeline Images!${NC}"
echo ""
echo "📋 Next Steps:"
echo "1. Open pipeline-diagram.mmd in your favorite editor"
echo "2. Copy the content to Mermaid Live Editor"
echo "3. Customize colors and styling"
echo "4. Export as high-resolution image"
echo "5. Use in presentations, documentation, or reports"
echo ""
echo "🔗 Quick Links:"
echo "   - Mermaid Live: https://mermaid.live/"
echo "   - Draw.io: https://app.diagrams.net/"
echo "   - Canva: https://www.canva.com/"
echo ""
echo -e "${BLUE}🚀 Happy visualizing!${NC}" 