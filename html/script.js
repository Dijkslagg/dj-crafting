let recipes = [];
let playerLevel = 1;
let playerXp = 0;
let craftingMenu = document.getElementById('crafting-menu');
let selectedRecipe = null;
let playerInventory = {};
let isCrafting = false;
let useProgression = false;
let currentTableId = null;

function canCraft(recipe) {
    if (playerLevel < recipe.levelRequired) return false;

    return recipe.materials.every(mat =>
        hasRequiredItems(mat.item, mat.amount)
    );
}

function calculateMaxCraftable(recipe) {
    let maxAmount = Infinity;
    recipe.materials.forEach(mat => {
        if (playerInventory[mat.item]) {
            const possibleCrafts = Math.floor(playerInventory[mat.item] / mat.amount);
            maxAmount = Math.min(maxAmount, possibleCrafts);
        } else {
            maxAmount = 0;
        }
    });
    return maxAmount;
}

let searchQuery = '';

function hasRequiredItems(itemName, required) {
    if (!playerInventory[itemName]) return false;
    return playerInventory[itemName] >= required;
}

let xpConfig = { baseXP: 100, multiplier: 1.0 }; 

function updateXPBar() {
    if (!xpConfig) {
        console.log("Missing xpConfig");
        return;
    }
    
    const xpForNextLevel = Math.round(xpConfig.baseXP * Math.pow(xpConfig.multiplier, playerLevel - 1));
    const xpProgress = (playerXp / xpForNextLevel) * 100;
    
    const xpFill = document.getElementById('xpFill');
    if (xpFill) {
        xpFill.style.width = `${xpProgress}%`;
    }
    document.getElementById('playerXP').textContent = `${playerXp}/${xpForNextLevel}`;
}

let activeCategory = 'all';

function renderCategories(categories) {
    const container = document.getElementById('categoryFilters');
    if (!container) return;

    container.innerHTML = `
        <div class="category-filter active" data-category="all">All</div>
        ${categories.map(category => `
            <div class="category-filter" data-category="${sanitizeInput(category)}">
                ${sanitizeInput(category.charAt(0).toUpperCase() + category.slice(1))}
            </div>
        `).join('')}
    `;

    container.querySelectorAll('.category-filter').forEach(filter => {
        filter.addEventListener('click', () => {
            activeCategory = filter.dataset.category;

            container.querySelectorAll('.category-filter').forEach(f =>
                f.classList.toggle('active', f === filter)
            );

            renderRecipes();
        });
    });
}

window.addEventListener('message', function(event) {
    if (event.data.action === "openCrafting") {
        recipes = event.data.recipes || [];
        playerLevel = parseInt(event.data.playerLevel) || 1;
        playerXp = parseInt(event.data.playerXp) || 0;
        playerInventory = event.data.inventory || {};
        xpConfig = event.data.progression || { baseXP: 100, multiplier: 1.0 };
        useProgression = event.data.useProgression || false;
        currentTableId = event.data.tableId;
        craftingMenu.classList.remove('hidden');

        const levelInfo = document.getElementById('levelInfo');
        if (levelInfo) {
            levelInfo.style.display = useProgression ? 'flex' : 'none';
        }

        document.querySelector('.player-info h2').textContent = sanitizeInput(event.data.tableName || "Crafting Workbench");
        if (useProgression) {
            document.getElementById('playerLevel').textContent = playerLevel;
            updateXPBar();
        }
        renderCategories(event.data.categories);
        renderRecipes();
    } else if (event.data.action === "closeCrafting") {
        craftingMenu.classList.add('hidden');
    } else if (event.data.action === "updateXP") {
        if (event.data.tableId === currentTableId) { 
            playerLevel = parseInt(event.data.level) || 1;
            playerXp = parseInt(event.data.xp) || 0;
            xpConfig = event.data.xpConfig;
            
            document.getElementById('playerLevel').textContent = playerLevel;
            updateXPBar();

            const xpFill = document.getElementById('xpFill');
            if (xpFill) {
                xpFill.classList.add('xp-gained');
                setTimeout(() => {
                    xpFill.classList.remove('xp-gained');
                }, 1000);
            }
        }
    } else if (event.data.action === "updateInventory") {
        playerInventory = event.data.inventory || {};
        renderRecipes();
    }
});

document.onkeyup = function (event) {
    if (event.key === 'Escape' && !isCrafting) {
        craftingMenu.classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/closeCrafting`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
};

document.getElementById('search').addEventListener('input', function (e) {
    searchQuery = e.target.value.toLowerCase();
    renderRecipes();
});

function renderRecipes() {
    const container = document.querySelector('.recipes-container');
    container.innerHTML = '';
    
    if (!recipes || recipes.length === 0) {
        container.innerHTML = '<div class="no-recipes">No recipes available</div>';
        return;
    }
    
    const filteredRecipes = recipes
        .filter(recipe => {
            const nameMatch = recipe.name.toLowerCase().includes(searchQuery);
            const categoryMatch = activeCategory === 'all' || recipe.category === activeCategory;
            const materialsMatch = recipe.materials.some(mat => 
                mat.item.toLowerCase().includes(searchQuery)
            );
            return (nameMatch || materialsMatch) && categoryMatch;
        })
        .sort((a, b) => a.levelRequired - b.levelRequired);
    
    filteredRecipes.forEach(recipe => {
        const hasRequiredLevel = useProgression ? (playerLevel >= recipe.levelRequired) : true;
        const hasAllMaterials = recipe.materials.every(mat => 
            hasRequiredItems(mat.item, mat.amount)
        );
        const canCraftRecipe = hasAllMaterials && hasRequiredLevel;

        const element = document.createElement('div');
        element.className = `recipe ${useProgression && !hasRequiredLevel ? 'locked' : ''}`;
        
        if (useProgression) {
            element.setAttribute('data-level', recipe.levelRequired);
        }
        
        const recipeHTML = `
            <div class="recipe-header">
                <div class="recipe-title">
                    <img src="nui://qb-inventory/html/images/${sanitizeInput(recipe.imageName)}.png" class="result-image">
                    <h3>${recipe.result.amount}x ${sanitizeInput(recipe.name)}</h3>
                </div>
                ${useProgression ? `<span class="level-req">Level ${recipe.levelRequired}</span>` : ''}
            </div>
            <div class="recipe-materials" data-recipe="${recipe.name}">
                ${renderMaterials(recipe, 1)}
            </div>
            <div class="recipe-info">
                <div class="recipe-details">
                    <span class="duration">Duration: <span class="total-duration" data-base-duration="${recipe.duration}">${recipe.duration}</span>s</span>
                    ${useProgression ? `<span class="xp-gain">+<span class="total-xp" data-base-xp="${recipe.xpGained}">${recipe.xpGained}</span> XP</span>` : ''}
                    <span class="max-craftable">Max: ${calculateMaxCraftable(recipe)}</span>
                </div>
                <div class="crafting-controls">
                    <input type="number" class="quantity-input" min="1" value="1" ${canCraftRecipe ? '' : 'disabled'}>
                    <button class="craft-btn" ${canCraftRecipe ? '' : 'disabled'}>Craft</button>
                </div>
            </div>
        `;

        element.innerHTML = recipeHTML;

        if (canCraftRecipe) {
            const quantityInput = element.querySelector('.quantity-input');
            const craftBtn = element.querySelector('.craft-btn');
            
            craftBtn.addEventListener('click', () => {
                const amount = parseInt(quantityInput.value) || 1;
                startCrafting(recipe, amount);
            });

            quantityInput.addEventListener('input', () => {
                let amount = parseInt(quantityInput.value) || 1;
                if (amount < 1) amount = 1;
                quantityInput.value = amount;
                
                const materialsContainer = element.querySelector('.recipe-materials');
                materialsContainer.innerHTML = renderMaterials(recipe, amount);
                
                if (useProgression) {
                    const xpElement = element.querySelector('.total-xp');
                    if (xpElement) {
                        const baseXp = parseInt(xpElement.getAttribute('data-base-xp')) || 0;
                        xpElement.textContent = baseXp * amount;
                    }
                }
                
                const durationElement = element.querySelector('.total-duration');
                if (durationElement) {
                    const baseDuration = parseInt(durationElement.getAttribute('data-base-duration')) || 0;
                    durationElement.textContent = baseDuration * amount;
                }
            });
        }

        container.appendChild(element);
    });
}

function renderMaterials(recipe, multiplier) {
    return recipe.materials.map(mat => {
        const required = mat.amount * multiplier;
        const hasEnough = hasRequiredItems(mat.item, required);
        return `
            <div class="material ${hasEnough ? '' : 'insufficient'}">
                <img src="nui://qb-inventory/html/images/${mat.imageName}.png">
                <span>${required}x ${mat.item}</span>
            </div>
        `;
    }).join('');
}

function startCrafting(recipe, amount) {
    if (amount < 1) {
        fetch(`https://${GetParentResourceName()}/showNotification`, {
            method: 'POST',
            body: JSON.stringify({
                type: 'error',
                message: 'Amount must be greater than 0!'
            })
        });
        return;
    }

    isCrafting = true;
    document.querySelectorAll('.craft-btn').forEach(btn => {
        btn.disabled = true;
    });

    const progressFill = document.querySelector('.progress-fill');
    progressFill.classList.add('crafting');

    const duration = recipe.duration * amount * 1000;
    let startTime = Date.now();

    fetch(`https://${GetParentResourceName()}/startCrafting`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ recipe, amount })
    });

    function updateProgress() {
        const elapsed = Date.now() - startTime;
        const percent = Math.min((elapsed / duration) * 100, 100);
        progressFill.style.width = `${percent}%`;

        if (percent < 100) {
            requestAnimationFrame(updateProgress);
        } else {
            progressFill.classList.remove('crafting');
            progressFill.classList.add('complete');
            setTimeout(() => {
                progressFill.classList.remove('complete');
                progressFill.style.width = '0%';
                document.querySelectorAll('.craft-btn').forEach(btn => {
                    btn.disabled = false;
                });
                isCrafting = false;
            }, 1000);
        }
    }

    updateProgress();
}

function sanitizeInput(str) {
    if (typeof str !== 'string') return '';
    return str.replace(/[&<>"']/g, function(match) {
        const escape = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#39;'
        };
        return escape[match];
    });
}
