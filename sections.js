class SectionManager {
    constructor() {
        this.overlayContainer = document.getElementById('overlay-container');
        this.externalContent = document.getElementById('external-content');

        this.setupEventListeners();
    }

    setupEventListeners() {
        const buttons = document.querySelectorAll('.monster-btn');
        if (buttons.length === 0) {
            console.error('No monster buttons found');
        } else {
            buttons.forEach((btn, index) => {
                btn.addEventListener('click', () => {
                    this.loadExternalContent(index);
                });
            });
        }
    }

    async loadExternalContent(index) {
        try {
            // Load specific external HTML file for each button
            const response = await fetch(`content/section${index}.html`);
            if (!response.ok) throw new Error('Failed to load section content');

            const htmlContent = await response.text();
            this.externalContent.innerHTML = htmlContent;

            // Ensure the external content scales properly within the homepage view
            this.updateScale();
            window.addEventListener('resize', this.updateScale.bind(this));

            // Show overlay container
            this.overlayContainer.classList.remove('hidden');
            this.overlayContainer.style.display = 'flex';

            // Disable interactions with the main content
            document.getElementById('wrapper').style.pointerEvents = 'none';

            // Add a close button to hide overlay
            const closeButton = document.createElement('button');
            closeButton.className = 'close-btn visible';
            closeButton.innerHTML = '&times;';
            this.externalContent.appendChild(closeButton);

            closeButton.onclick = () => this.hideExternalContent();

            // Apply animations to external content
            this.animateExternalContent();
        } catch (error) {
            console.error(error);
        }
    }

    hideExternalContent() {
        // Hide overlay container
        this.overlayContainer.classList.add('hidden');
        this.overlayContainer.style.display = 'none';

        // Enable interactions with the main content
        document.getElementById('wrapper').style.pointerEvents = 'auto';

        // Clear loaded content
        this.externalContent.innerHTML = '';

        // Remove resize event listener
        window.removeEventListener('resize', this.updateScale.bind(this));
    }

    animateExternalContent() {
        // Apply animations to elements within the external content
        const elementsToAnimate = this.externalContent.querySelectorAll('.animate');
        elementsToAnimate.forEach((element, index) => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(20px)';
            setTimeout(() => {
                element.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, index * 100);
        });
    }

    updateScale() {
        const wrapperWidth = window.innerWidth;
        const wrapperHeight = window.innerHeight;
        const baseWidth = 1920;
        const baseHeight = 1280;

        const scale = Math.min(
            wrapperWidth / baseWidth,
            wrapperHeight / baseHeight
        );

        this.overlayContainer.style.transform = `scale(${scale})`;
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new SectionManager();
});
