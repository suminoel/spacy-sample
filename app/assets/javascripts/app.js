$(function(){
	var flag = false;
	var isMobile = false;
	var tabMenu = $('.tab-wrap li a');

	// mobile
	if (window.matchMedia('(max-width:550px)').matches) {
		isMobile = true;
		tabMenu = $('.tab-wrap-sp li a');
		$('.tab-panel').removeClass('active');
	}
	// pc
	else {
		// postsページ以外は投稿・検索のタブを表示しない
		if (location.href.indexOf('/posts/') === false) {
			$('.tab-wrap').hide();
			tabMenu.removeClass('active');
			$('.tab-panel').removeClass('active');
		}
	}

	// click sp-nav-btn
	$('.sp-menu-btn > span').on('click', function(){
		// flagがfalseならメニューを開く
		if(!flag) {
			$('.sp-header-menus').show();
			$('.sp-header-menus').animate({'margin-right': 0}, 'fast');
			flag = true;
		}

		// flagがtrueならメニューを閉じる
		else {
			$('.sp-header-menus').animate({'margin-right': '-300px'}, 'fast', function(){
				$('.sp-header-menus').hide();
			});
			flag = false;
		}
	});

	// キーワード検索をした場合
	if (location.search.indexOf('?q=') >= 0) {
		// キーワード検索のタブをactiveにする
		tabMenu.removeClass('active');
		$('.tab-panel').removeClass('active');
		$('.search-kwd-tab, .search-kwd-tab-sp').addClass('active');
		$('.search-kwd-panel, .search-kwd-panel-sp').addClass('active');
	}
	// タグ検索をした場合
	else if (location.href.indexOf('tags_search') >= 0) {
		// タグ検索のタブをactiveにする
		tabMenu.removeClass('active');
		$('.tab-panel').removeClass('active');
		$('.search-tag-tab, .search-tag-tab-sp').addClass('active');
		$('.search-tag-panel, .search-tag-panel-sp').addClass('active');
	}

	// タブ
	tabMenu.click(function() {
		var index = tabMenu.index(this);
		var tagInputWidth = $('.select2-selection__rendered').width();

		if (isMobile === true) {
			// home
			if (index == 0) {
				tabMenu.removeClass('active');
				$('.tab-panel').removeClass('active');
				$(this).addClass('active');
				return;
			}

			if ($(this).hasClass('active')) {
				$('.tab-panel').eq(index - 1).toggleClass('active');
			} else {
				tabMenu.removeClass('active');
				$('.tab-panel').removeClass('active');
				$(this).addClass('active');
				$('.select2-search__field').css('width', tagInputWidth);
				$('.tab-panel').eq(index - 1).toggleClass('active');
			}
		} else {
			tabMenu.removeClass('active');
			$('.tab-panel').removeClass('active');
			$(this).addClass('active');
			$('.select2-search__field').css('width', tagInputWidth);
			$('.tab-panel').eq(index).addClass('active');
		}
	});

	// タグ検索
	$('.searchable').select2({
		placeholder: "タグを選択してください（検索可能）",
		width: "100%",
		allowClear: true
	});

	// 無限スクロール
	$('.post-loop-wrap').infiniteScroll({
		// options
		path: 'nav.pagination a[rel=next]',
		append: '.posts-index-item',
		history: false,
	});

	// postのどこかをクリックしたとき
	// document.on〜の形式にしないと、jQueryで追加した要素が反応しないので注意
	$(document).on('click', '.posts-index-item', function(e){
		var cls = e.target.className;// クリックした要素のclassを取得

		// classがposts-index-item、post-right、post-contentのどれかだったら
		if( cls == 'posts-index-item' || cls == 'post-right' || cls == 'post-content' ) {
			// post-index-itemについているdata-linkの値のページにリダイレクトする
			window.location = $(this).data('link');
		}
	});

	// flashを一定時間で消す
	$(window).load(function(){
		if( $('.flash').length != 0 ) {
			$('.flash').delay(5000).fadeOut();
		}
	});

});
