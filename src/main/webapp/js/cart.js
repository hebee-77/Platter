/**
 * PLATTER — CART PAGE INTERACTIVITY
 * Asynchronous AJAX handling for Cart operations
 */

document.addEventListener('DOMContentLoaded', () => {
    initCartHandlers();
});

function initCartHandlers() {
    const cartContainer = document.getElementById('cartItemsList');
    if (!cartContainer) return;

    cartContainer.addEventListener('click', (e) => {
        const decBtn = e.target.closest('.qty-decrease');
        const incBtn = e.target.closest('.qty-increase');
        const removeBtn = e.target.closest('.remove-btn');

        if (decBtn) {
            const card = decBtn.closest('.cart-item-card');
            const dishId = card.dataset.dishId;
            updateCartItem(dishId, 'decrement', card);
        } else if (incBtn) {
            const card = incBtn.closest('.cart-item-card');
            const dishId = card.dataset.dishId;
            updateCartItem(dishId, 'increment', card);
        } else if (removeBtn) {
            const card = removeBtn.closest('.cart-item-card');
            const dishId = card.dataset.dishId;
            updateCartItem(dishId, 'remove', card);
        }
    });
}

function updateCartItem(dishId, action, cardElement) {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    const url = (contextPath ? contextPath : '') + '/cart-api';

    const params = new URLSearchParams();
    params.append('dishId', dishId);
    params.append('action', action);

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: params.toString()
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.error) {
            console.error('Cart API error:', data.error);
            return;
        }

        // data structure: { dishId: 12, newQty: 2, cartItemCount: 3, cartTotal: 540 }
        const unitPrice = parseFloat(cardElement.dataset.price || 0);

        if (data.newQty === 0 || action === 'remove') {
            cardElement.style.transition = 'all 0.3s ease';
            cardElement.style.opacity = '0';
            cardElement.style.transform = 'scale(0.95)';
            setTimeout(() => {
                cardElement.remove();
                checkEmptyState(data.cartItemCount);
            }, 300);
        } else {
            const qtyVal = cardElement.querySelector('.qty-val');
            const lineTotal = cardElement.querySelector('.cart-item-line-total');

            if (qtyVal) qtyVal.textContent = data.newQty;
            if (lineTotal) lineTotal.textContent = '₹' + (unitPrice * data.newQty).toFixed(0);
        }

        updateTotals(data.cartTotal, data.cartItemCount);
    })
    .catch(err => {
        console.error('Failed to update cart:', err);
    });
}

function updateTotals(subtotal, count) {
    const subtotalEl = document.getElementById('subtotal');
    const totalEl = document.getElementById('total');
    const taxesEl = document.getElementById('taxes');
    const deliveryFeeEl = document.getElementById('deliveryFee');
    const navBadge = document.getElementById('navCartBadge');

    const deliveryFee = count > 0 ? 40 : 0;
    const taxes = Math.round(subtotal * 0.05); // 5% tax
    const grandTotal = subtotal + deliveryFee + taxes;

    if (subtotalEl) subtotalEl.textContent = '₹' + subtotal;
    if (deliveryFeeEl) deliveryFeeEl.textContent = count > 0 ? '₹' + deliveryFee : 'Free';
    if (taxesEl) taxesEl.textContent = '₹' + taxes;
    if (totalEl) totalEl.textContent = '₹' + grandTotal;
    if (navBadge) navBadge.textContent = count;
}

function checkEmptyState(count) {
    const cartList = document.getElementById('cartItemsList');
    const emptyCard = document.getElementById('emptyCart');
    const cartGrid = document.querySelector('.cart-grid');

    if (count === 0 || (cartList && cartList.children.length === 0)) {
        if (cartGrid) cartGrid.style.display = 'none';
        if (emptyCard) emptyCard.classList.add('is-visible');
    }
}
