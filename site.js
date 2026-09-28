// Site-wide chrome: injects the burger menu and footer links into every page,
// so there is a single source of truth for navigation. Pages provide the mount
// points <div data-site-menu></div> (inside a positioned header) and
// <div data-site-footer></div> (inside <footer>).
(function(){
  const root = location.pathname.includes('/blog/') ? '../' : '';

  const menuMount = document.querySelector('[data-site-menu]');
  if(menuMount){
    menuMount.innerHTML = `
      <details class="menu" id="menu">
        <summary class="menu-toggle" aria-label="Меню" aria-haspopup="true">
          <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="4" y1="7" x2="20" y2="7"/><line x1="4" y1="12" x2="20" y2="12"/><line x1="4" y1="17" x2="20" y2="17"/></svg>
        </summary>
        <nav class="menu-panel" aria-label="Головне меню">
          <a href="${root}#top">Тренування</a>
          <a href="${root}#stages">Заняття</a>
          <a href="${root}#rules">Правила безпеки</a>
          <a href="${root}blog/">Блог</a>
          <span class="menu-sep" role="separator"></span>
          <a href="https://volovod.com/trainings" target="_blank" rel="noopener">Реєстрація</a>
          <a href="https://t.me/+NX635BITfD5lZWVi" target="_blank" rel="noopener">Telegram-група</a>
          <a href="https://velosotka.github.io/" target="_blank" rel="noopener">Київська Сотка</a>
        </nav>
      </details>`;
    const menu = menuMount.querySelector('#menu');
    menu.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>menu.removeAttribute('open')));
    document.addEventListener('click',e=>{if(menu.open && !menu.contains(e.target))menu.removeAttribute('open');});
  }

  const footerMount = document.querySelector('[data-site-footer]');
  if(footerMount){
    footerMount.innerHTML = `
      <h3>Автор</h3>
      <p><a href="https://github.com/alexandear" target="_blank" rel="noopener">Олександр Редько</a></p>
      <p><a href="https://github.com/alexandear/cycling101" target="_blank" rel="noopener">Код вебсайту</a></p>
      <nav class="footer-nav" aria-label="Корисні посилання">
        <a href="https://volovod.com/trainings" target="_blank" rel="noopener">Реєстрація</a>
        <a href="https://t.me/+NX635BITfD5lZWVi" target="_blank" rel="noopener">Telegram-група</a>
        <a href="https://velosotka.github.io/" target="_blank" rel="noopener">Київська Сотка</a>
        <a href="https://instagram.com/oleksandr.red" target="_blank" rel="noopener">Інструктор</a>
        <a href="https://github.com/alexandear/cycling101" target="_blank" rel="noopener">Код сайту</a>
      </nav>`;
  }
})();
