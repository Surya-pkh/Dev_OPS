// Enhanced GitHub API integration
const username = "Surya-pkh";
const repoList = document.getElementById("repo-list");

// Add loading state management
let isLoading = false;
let reposLoaded = false;

function showLoading() {
  if (repoList) {
    repoList.innerHTML = '<li><div class="loading"></div> <span>Loading awesome projects...</span></li>';
    isLoading = true;
  }
}

function hideLoading() {
  isLoading = false;
}

function showError(message) {
  if (repoList) {
    repoList.innerHTML = `
      <li style="color: var(--text-secondary); text-align: center; padding: 2rem;">
        <i class="fa-solid fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 1rem; color: #f5576c;"></i>
        <br>${message}
        <br><small>Please check your internet connection and try again.</small>
      </li>
    `;
  }
}

function createRepoElement(repo, index) {
  const li = document.createElement("li");
  li.style.animationDelay = `${index * 0.1}s`;
  
  // Get language color (simplified mapping)
  const languageColors = {
    'JavaScript': '#f1e05a',
    'Python': '#3572A5',
    'HTML': '#e34c26',
    'CSS': '#563d7c',
    'Java': '#b07219',
    'TypeScript': '#2b7489',
    'Shell': '#89e051',
    'Dockerfile': '#384d54',
    'Go': '#00ADD8',
    'Rust': '#dea584'
  };
  
  const languageColor = languageColors[repo.language] || '#6e7681';
  
  li.innerHTML = `
    <div class="repo-header">
      <a href="${repo.html_url}" target="_blank" class="repo-link">
        <i class="fa-brands fa-github"></i>
        <span class="repo-name">${repo.name}</span>
      </a>
      ${repo.private ? '<span class="private-badge">Private</span>' : ''}
    </div>
    
    ${repo.description ? `<p class="repo-description">${repo.description}</p>` : ''}
    
    <div class="repo-stats">
      ${repo.language ? `
        <span class="repo-language">
          <span class="language-dot" style="background-color: ${languageColor};"></span>
          ${repo.language}
        </span>
      ` : ''}
      
      <span class="repo-stars">
        <i class="fa-solid fa-star"></i>
        ${repo.stargazers_count}
      </span>
      
      <span class="repo-forks">
        <i class="fa-solid fa-code-fork"></i>
        ${repo.forks_count}
      </span>
      
      <span class="repo-updated">
        <i class="fa-solid fa-clock"></i>
        ${formatDate(repo.updated_at)}
      </span>
    </div>
  `;
  
  return li;
}

function formatDate(dateString) {
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  if (diffDays === 1) return 'Yesterday';
  if (diffDays < 7) return `${diffDays} days ago`;
  if (diffDays < 30) return `${Math.ceil(diffDays / 7)} weeks ago`;
  if (diffDays < 365) return `${Math.ceil(diffDays / 30)} months ago`;
  return `${Math.ceil(diffDays / 365)} years ago`;
}

// Enhanced fetch with retry mechanism
async function fetchWithRetry(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      return response;
    } catch (error) {
      if (i === retries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
}

// Main function to load GitHub repositories
async function loadGitHubRepos() {
  if (reposLoaded || isLoading || !repoList) return;
  
  showLoading();
  
  try {
    // Fetch repositories with enhanced parameters
    const response = await fetchWithRetry(
      `https://api.github.com/users/${username}/repos?sort=updated&per_page=12&type=public`
    );
    
    const repos = await response.json();
    
    if (!Array.isArray(repos)) {
      throw new Error('Invalid response format');
    }
    
    hideLoading();
    repoList.innerHTML = '';
    
    if (repos.length === 0) {
      repoList.innerHTML = `
        <li style="text-align: center; color: var(--text-secondary); padding: 2rem;">
          <i class="fa-solid fa-folder-open" style="font-size: 2rem; margin-bottom: 1rem;"></i>
          <br>No public repositories found.
        </li>
      `;
      return;
    }
    
    // Filter out forked repos and sort by stars/activity
    const filteredRepos = repos
      .filter(repo => !repo.fork)
      .sort((a, b) => {
        // Sort by stars first, then by last updated
        if (b.stargazers_count !== a.stargazers_count) {
          return b.stargazers_count - a.stargazers_count;
        }
        return new Date(b.updated_at) - new Date(a.updated_at);
      })
      .slice(0, 8); // Show top 8 repos
    
    // Create repo elements with staggered animation
    filteredRepos.forEach((repo, index) => {
      const repoElement = createRepoElement(repo, index);
      repoList.appendChild(repoElement);
    });
    
    reposLoaded = true;
    
    // Add success indicator
    setTimeout(() => {
      const successMsg = document.createElement('div');
      successMsg.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: var(--success-gradient);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.9rem;
        z-index: 1000;
        opacity: 0;
        transition: opacity 0.3s ease;
      `;
      successMsg.innerHTML = '<i class="fa-solid fa-check"></i> Projects loaded successfully!';
      document.body.appendChild(successMsg);
      
      setTimeout(() => successMsg.style.opacity = '1', 100);
      setTimeout(() => {
        successMsg.style.opacity = '0';
        setTimeout(() => successMsg.remove(), 300);
      }, 3000);
    }, 500);
    
  } catch (error) {
    hideLoading();
    console.error('GitHub API Error:', error);
    
    if (error.message.includes('403')) {
      showError('API rate limit exceeded. Please try again later.');
    } else if (error.message.includes('404')) {
      showError('GitHub user not found.');
    } else if (!navigator.onLine) {
      showError('No internet connection detected.');
    } else {
      showError('Failed to load repositories. Please try again later.');
    }
  }
}

// Enhanced CSS for repository cards
const repoStyles = document.createElement('style');
repoStyles.textContent = `
  .repo-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 0.8rem;
  }
  
  .repo-link {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
    color: var(--text-accent);
    font-weight: 600;
    transition: all 0.3s ease;
  }
  
  .repo-link:hover {
    color: var(--text-primary);
    transform: translateX(5px);
  }
  
  .repo-name {
    font-family: 'JetBrains Mono', monospace;
  }
  
  .private-badge {
    background: var(--warning-gradient);
    color: white;
    padding: 0.2rem 0.5rem;
    border-radius: 10px;
    font-size: 0.7rem;
    text-transform: uppercase;
    font-weight: 600;
  }
  
  .repo-description {
    color: var(--text-secondary);
    font-size: 0.9rem;
    line-height: 1.4;
    margin-bottom: 1rem;
    opacity: 0.8;
  }
  
  .repo-stats {
    display: flex;
    align-items: center;
    gap: 1rem;
    font-size: 0.8rem;
    color: var(--text-secondary);
    flex-wrap: wrap;
  }
  
  .repo-stats > span {
    display: flex;
    align-items: center;
    gap: 0.3rem;
    transition: color 0.3s ease;
  }
  
  .repo-stats > span:hover {
    color: var(--text-primary);
  }
  
  .language-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    display: inline-block;
  }
  
  .repo-language {
    font-weight: 500;
  }
  
  .repo-stars i {
    color: #ffc107;
  }
  
  .repo-forks i {
    color: var(--text-accent);
  }
  
  .repo-updated i {
    color: var(--text-secondary);
  }
  
  @media (max-width: 768px) {
    .repo-stats {
      gap: 0.5rem;
      font-size: 0.75rem;
    }
    
    .repo-header {
      flex-direction: column;
      align-items: flex-start;
      gap: 0.5rem;
    }
  }
`;
document.head.appendChild(repoStyles);

// Auto-load repositories when the page contains the repo list
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('repo-list')) {
      setTimeout(loadGitHubRepos, 500);
    }
  });
} else {
  if (document.getElementById('repo-list')) {
    setTimeout(loadGitHubRepos, 500);
  }
}

// Add refresh functionality
function addRefreshButton() {
  if (!repoList) return;
  
  const refreshBtn = document.createElement('button');
  refreshBtn.innerHTML = '<i class="fa-solid fa-refresh"></i> Refresh Projects';
  refreshBtn.style.cssText = `
    background: var(--card-bg);
    border: 1px solid var(--glass-border);
    color: var(--text-primary);
    padding: 0.7rem 1.5rem;
    border-radius: 20px;
    cursor: pointer;
    margin-top: 1rem;
    backdrop-filter: blur(10px);
    transition: all 0.3s ease;
    font-family: inherit;
  `;
  
  refreshBtn.addEventListener('click', () => {
    reposLoaded = false;
    loadGitHubRepos();
  });
  
  refreshBtn.addEventListener('mouseenter', () => {
    refreshBtn.style.background = 'var(--card-hover)';
    refreshBtn.style.transform = 'translateY(-2px)';
  });
  
  refreshBtn.addEventListener('mouseleave', () => {
    refreshBtn.style.background = 'var(--card-bg)';
    refreshBtn.style.transform = 'translateY(0)';
  });
  
  repoList.parentNode.appendChild(refreshBtn);
}

// Add refresh button after initial load
setTimeout(addRefreshButton, 2000);