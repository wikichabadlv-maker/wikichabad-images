-- יחידה:ניווט קבוצות — תבנית ניווט מקורית של ויקיחב"ד.
-- פרמטרים: כותרת, למעלה, קבוצה1..40 + רשימה1..40 (+ תמונהN: דיוקן קטן ליד שם הקבוצה, פרטN: שורת משנה קטנה),
-- למטה, מוסתר (כן = מקופלת), (צבע וסמל אינם בשימוש: עיצוב אחיד לכל התבניות).
-- העיצוב ב[[תבנית:ניווט קבוצות/styles.css]].
local p = {}

local function nonEmpty(v)
	return v ~= nil and mw.text.trim(v) ~= ''
end

function p.main(frame)
	local args = frame:getParent().args
	local styles = frame:extensionTag('templatestyles', '', { src = 'תבנית:ניווט קבוצות/styles.css' })
	local root = mw.html.create('table'):addClass('navbox'):addClass('wc-navbox'):addClass('mw-collapsible')
	if nonEmpty(args['מוסתר']) then root:addClass('mw-collapsed') end
	local th = root:tag('tr'):tag('th'):attr('colspan', '2'):addClass('wc-nav-title')
	if nonEmpty(args['סמל']) then
		th:tag('span'):addClass('wc-nav-emblem'):wikitext('[[קובץ:' .. mw.text.trim(args['סמל']) .. '|22px|קישור=|alt=]]')
	end
	th:tag('span'):addClass('wc-nav-title-text'):wikitext(args['כותרת'] or '')
	if nonEmpty(args['למעלה']) then
		root:tag('tr'):tag('td'):attr('colspan', '2'):addClass('wc-nav-above'):wikitext(args['למעלה'])
	end
	local row = 0
	for i = 1, 40 do
		local g, l = args['קבוצה' .. i], args['רשימה' .. i]
		if nonEmpty(l) then
			row = row + 1
			local tr = root:tag('tr')
			local cls = row % 2 == 0 and 'wc-nav-even' or 'wc-nav-odd'
			if nonEmpty(g) then
				local gth = tr:tag('th'):attr('scope', 'row'):addClass('wc-nav-group')
				if nonEmpty(args['תמונה' .. i]) then
					gth:tag('span'):addClass('wc-nav-portrait'):wikitext('[[קובץ:' .. mw.text.trim(args['תמונה' .. i]) .. '|40x50px|קישור=|alt=]]')
				end
				gth:tag('span'):addClass('wc-nav-gname'):wikitext(g)
				if nonEmpty(args['פרט' .. i]) then
					gth:tag('span'):addClass('wc-nav-gsub'):wikitext(args['פרט' .. i])
				end
				tr:tag('td'):addClass('wc-nav-list'):addClass(cls):wikitext('\n' .. l .. '\n')
			else
				tr:tag('td'):attr('colspan', '2'):addClass('wc-nav-list'):addClass(cls):wikitext('\n' .. l .. '\n')
			end
		end
	end
	if nonEmpty(args['למטה']) then
		root:tag('tr'):tag('td'):attr('colspan', '2'):addClass('wc-nav-below'):wikitext(args['למטה'])
	end
	return styles .. tostring(root)
end

return p
