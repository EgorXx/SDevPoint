(() => {
    const cards = document.querySelectorAll('.home-card');

    cards.forEach((card) => {
        card.addEventListener('pointermove', (event) => {
            const rect = card.getBoundingClientRect();

            const x = event.clientX - rect.left;
            const y = event.clientY - rect.top;

            card.style.setProperty('--card-pointer-x', `${x}px`);
            card.style.setProperty('--card-pointer-y', `${y}px`);
        });

        card.addEventListener('pointerleave', () => {
            card.style.removeProperty('--card-pointer-x');
            card.style.removeProperty('--card-pointer-y');
        });
    });
})();