// Enhanced particle system
function createParticle() {
  const particle = document.createElement('div');
  particle.className = 'particle';
  particle.style.left = Math.random() * 100 + '%';
  particle.style.animationDelay = Math.random() * 12 + 's';
  particle.style.animationDuration = (Math.random() * 4 + 8) + 's';
  document.body.appendChild(particle);
  
  setTimeout(() => {
    if (particle.parentNode) {
      particle.remove();
    }
  }, 12000);
}

// Create particles more frequently
setInterval(createParticle, 800);

// Enhanced navbar scroll effect
let lastScrollY = window.scrollY;
window.addEventListener('scroll', () => {
  const navbar = document.querySelector('.navbar');
  const scrollY = window.scrollY;
  
  if (scrollY > 100) {
    navbar.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
  }
  
  // Hide navbar on scroll down, show on scroll up
  if (scrollY > lastScrollY && scrollY > 200) {
    navbar.style.transform = 'translateY(-100%)';
  } else {
    navbar.style.transform = 'translateY(0)';
  }
  
  lastScrollY = scrollY;
});

// Enhanced mouse parallax effect
document.addEventListener('mousemove', (e) => {
  const mouseX = (e.clientX / window.innerWidth - 0.5) * 2;
  const mouseY = (e.clientY / window.innerHeight - 0.5) * 2;
  
  const cards = document.querySelectorAll('.card, .container');
  cards.forEach(card => {
    const intensity = 15;
    const moveX = mouseX * intensity;
    const moveY = mouseY * intensity;
    
    card.style.transform = `translate(${moveX}px, ${moveY}px)`;
  });
});

// Reset card positions when mouse leaves
document.addEventListener('mouseleave', () => {
  const cards = document.querySelectorAll('.card, .container');
  cards.forEach(card => {
    card.style.transform = 'translate(0, 0)';
  });
});

// Enhanced typing effect for the highlight text
function typeWriter(element, text, speed = 100) {
  if (!element) return;
  
  element.textContent = '';
  let i = 0;
  
  const type = () => {
    if (i < text.length) {
      element.textContent += text.charAt(i);
      i++;
      setTimeout(type, speed);
    }
  };
  
  setTimeout(type, 1000);
}

// Initialize typing effect when page loads
document.addEventListener('DOMContentLoaded', () => {
  const highlight = document.querySelector('.highlight');
  if (highlight) {
    const text = highlight.textContent;
    typeWriter(highlight, text, 80);
  }
});

// Smooth scroll for scroll indicator
document.addEventListener('DOMContentLoaded', () => {
  const scrollIndicator = document.querySelector('.scroll-indicator');
  if (scrollIndicator) {
    scrollIndicator.addEventListener('click', () => {
      window.location.href = 'skills.html';
    });
  }
});

// Performance optimization with Intersection Observer
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.animationPlayState = 'running';
      entry.target.classList.add('visible');
    }
  });
}, observerOptions);

// Observe elements when they come into view
document.addEventListener('DOMContentLoaded', () => {
  const animateElements = document.querySelectorAll('.skills li, .projects li, .card, .container');
  animateElements.forEach(el => {
    observer.observe(el);
  });
});

// Enhanced button hover effects with ripple
document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('.button');
  buttons.forEach(button => {
    button.addEventListener('mouseenter', (e) => {
      // Create ripple effect
      const ripple = document.createElement('span');
      ripple.style.position = 'absolute';
      ripple.style.borderRadius = '50%';
      ripple.style.background = 'rgba(255, 255, 255, 0.3)';
      ripple.style.transform = 'scale(0)';
      ripple.style.animation = 'ripple 0.6s linear';
      ripple.style.left = '50%';
      ripple.style.top = '50%';
      ripple.style.width = '20px';
      ripple.style.height = '20px';
      ripple.style.marginLeft = '-10px';
      ripple.style.marginTop = '-10px';
      ripple.style.pointerEvents = 'none';
      
      button.appendChild(ripple);
      
      setTimeout(() => {
        if (ripple.parentNode) {
          ripple.remove();
        }
      }, 600);
    });
  });
});

// Add ripple keyframes to document
const style = document.createElement('style');
style.textContent = `
  @keyframes ripple {
    to {
      transform: scale(4);
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);

// Keyboard navigation enhancement
document.addEventListener('keydown', (e) => {
  // Navigate with arrow keys
  if (e.key === 'ArrowRight' && window.location.pathname.includes('index.html')) {
    window.location.href = 'skills.html';
  } else if (e.key === 'ArrowLeft' && window.location.pathname.includes('skills.html')) {
    window.location.href = 'index.html';
  }
  
  // Press 'h' for home, 's' for skills
  if (e.key.toLowerCase() === 'h') {
    window.location.href = 'index.html';
  } else if (e.key.toLowerCase() === 's') {
    window.location.href = 'skills.html';
  }
});

// Enhanced scroll animations
function handleScrollAnimations() {
  const elements = document.querySelectorAll('.card, .container, .skills li, .projects li');
  
  elements.forEach(element => {
    const elementTop = element.getBoundingClientRect().top;
    const elementVisible = 150;
    
    if (elementTop < window.innerHeight - elementVisible) {
      element.classList.add('animate-in');
    }
  });
}

window.addEventListener('scroll', handleScrollAnimations);

// Add smooth page transitions
function addPageTransition() {
  const links = document.querySelectorAll('a[href$=".html"]');
  
  links.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const href = link.getAttribute('href');
      
      // Create transition overlay
      const overlay = document.createElement('div');
      overlay.style.position = 'fixed';
      overlay.style.top = '0';
      overlay.style.left = '0';
      overlay.style.width = '100%';
      overlay.style.height = '100%';
      overlay.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
      overlay.style.zIndex = '9999';
      overlay.style.opacity = '0';
      overlay.style.transition = 'opacity 0.3s ease';
      
      document.body.appendChild(overlay);
      
      setTimeout(() => {
        overlay.style.opacity = '1';
      }, 10);
      
      setTimeout(() => {
        window.location.href = href;
      }, 300);
    });
  });
}

// Initialize page transitions when DOM is loaded
document.addEventListener('DOMContentLoaded', addPageTransition);

// Add mouse trail effect
let mouseTrail = [];
const maxTrailLength = 20;

document.addEventListener('mousemove', (e) => {
  mouseTrail.push({ x: e.clientX, y: e.clientY, time: Date.now() });
  
  if (mouseTrail.length > maxTrailLength) {
    mouseTrail.shift();
  }
  
  // Create trail particles occasionally
  if (Math.random() < 0.1) {
    createTrailParticle(e.clientX, e.clientY);
  }
});

function createTrailParticle(x, y) {
  const particle = document.createElement('div');
  particle.style.position = 'fixed';
  particle.style.left = x + 'px';
  particle.style.top = y + 'px';
  particle.style.width = '4px';
  particle.style.height = '4px';
  particle.style.background = 'rgba(79, 172, 254, 0.6)';
  particle.style.borderRadius = '50%';
  particle.style.pointerEvents = 'none';
  particle.style.zIndex = '1000';
  particle.style.transition = 'all 0.5s ease';
  
  document.body.appendChild(particle);
  
  setTimeout(() => {
    particle.style.opacity = '0';
    particle.style.transform = 'scale(0)';
  }, 50);
  
  setTimeout(() => {
    if (particle.parentNode) {
      particle.remove();
    }
  }, 550);
}

// Enhanced loading animation
function showLoadingComplete() {
  const loadingElements = document.querySelectorAll('.loading');
  loadingElements.forEach(el => {
    el.style.display = 'none';
  });
}

// Add floating animation to cards on hover
document.addEventListener('DOMContentLoaded', () => {
  const cards = document.querySelectorAll('.card, .container');
  cards.forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.style.animation = 'float 3s ease-in-out infinite';
    });
    
    card.addEventListener('mouseleave', () => {
      card.style.animation = '';
    });
  });
});

// Add floating keyframe animation
const floatStyle = document.createElement('style');
floatStyle.textContent = `
  @keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
  }
`;
document.head.appendChild(floatStyle);