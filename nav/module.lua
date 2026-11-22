-- יחידה:ניווט קבוצות — תבנית ניווט עם שורות לפי קבוצות, מקורית של ויקיחב"ד.
-- פרמטרים: כותרת, למעלה, קבוצה1..40 + רשימה1..40, למטה, מוסתר (כן = מוסתרת כברירת מחדל), צבע (רקע הכותרת).
-- העיצוב ב[[תבנית:ניווט קבוצות/styles.css]].
local p = {}

local function nonEmpty(v)
	return v ~= nil and mw.text.trim(v) ~= ''
end

function p.main(frame)
	local args = frame:getParent().args
	local styles = frame:extensionTag('templatestyles', '', { src = 'תבנית:ניווט קבוצות/styles.css' })
	local root = mw.html.create('table'):addClass('navbox'):addClass('wc-navbox')
	if nonEmpty(args['מוסתר']) then
		root:addClass('mw-collapsible'):addClass('mw-collapsed')
	else
		root:addClass('mw-collapsible')
	end
	local th = root:tag('tr'):tag('th'):attr('colspan', '2'):addClass('wc-nav-title'):wikitext(args['כותרת'] or '')
	if nonEmpty(args['צבע']) then th:css('background-color', mw.text.trim(args['צבע'])) end
	if nonEmpty(args['למעלה']) then
		root:tag('tr'):tag('td'):attr('colspan', '2'):addClass('wc-nav-above'):wikitext(args['למעלה'])
	end
	for i = 1, 40 do
		local g, l = args['קבוצה' .. i], args['רשימה' .. i]
		if nonEmpty(l) then
			local tr = root:tag('tr')
			if nonEmpty(g) then
				tr:tag('th'):attr('scope', 'row'):addClass('wc-nav-group'):wikitext(g)
				tr:tag('td'):addClass('wc-nav-list'):addClass(i % 2 == 0 and 'wc-nav-even' or 'wc-nav-odd'):wikitext('\n' .. l .. '\n')
			else
				tr:tag('td'):attr('colspan', '2'):addClass('wc-nav-list'):addClass(i % 2 == 0 and 'wc-nav-even' or 'wc-nav-odd'):wikitext('\n' .. l .. '\n')
			end
		end
	end
	if nonEmpty(args['למטה']) then
		root:tag('tr'):tag('td'):attr('colspan', '2'):addClass('wc-nav-below'):wikitext(args['למטה'])
	end
	return styles .. tostring(root)
end

return p
