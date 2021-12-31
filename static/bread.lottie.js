fetch('bread.lottie.json')
    .then(res => res.json())
    .then(out =>
        lottie.loadAnimation({
            container: document.getElementById('sticker'),
            renderer: 'svg',
            loop: true,
            autoplay: true,
            animationData: out
        }));