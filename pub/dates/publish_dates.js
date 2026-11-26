// Run in a wikichabad.org tab signed in as הנהלה. Results in window.__D (also localStorage __dates).
window.__D=window.__D||{tpl:{},pages:{},redir:{},real:[],done:false};
window.__runDates=async()=>{
 const D=window.__D;
 const B='https://raw.githubusercontent.com/wikichabadlv-maker/wikichabad-images/main/pub/dates/';
 const all=await (await fetch(B+'all.json?t='+Date.now())).json();
 const red=await (await fetch(B+'redirects.json?t='+Date.now())).json();
 const api=async(params,post)=>{if(!post)return (await fetch('/api.php?format=json&formatversion=2&'+new URLSearchParams(params))).json();const fd=new FormData();for(const [k,v] of Object.entries(params))fd.append(k,v);fd.append('format','json');fd.append('formatversion','2');return (await fetch('/api.php',{method:'POST',body:fd})).json();};
 const T=async()=>(await api({action:'query',meta:'tokens'})).query.tokens.csrftoken;
 const cur=async t=>{const r=await api({action:'query',titles:t,prop:'revisions',rvprop:'content',rvslots:'main'});const p=r.query.pages[0];return p.missing?null:p.revisions[0].slots.main.content};
 const save=()=>{try{localStorage.setItem('__dates',JSON.stringify(D))}catch(_){}};
 const S='פרסום ערך תאריך מסביבת העבודה';
 // 1. templates (replace if exist)
 for(const [t,w] of Object.entries(all.tpl)){if(D.tpl[t]==='ok')continue;
  const c=await cur(t); if(c===w){D.tpl[t]='ok';continue}
  const e=await api({action:'edit',title:t,text:w,summary:S,token:await T()},true); D.tpl[t]=e.edit?'ok':JSON.stringify(e.error).slice(0,120); save()}
 // 2. pages: create; overwrite only redirects; never real entries
 for(const [t,w] of Object.entries(all.pages)){const o=D.pages[t];if(o&&(o.rev||o==='REAL'))continue;
  try{const c=await cur(t);
   if(c!==null&&!/^\s*#(הפניה|redirect)/i.test(c)){D.pages[t]='REAL';D.real.push(t);save();continue}
   const p={action:'edit',title:t,text:w,summary:S,token:await T()}; if(c===null)p.createonly='1';
   const e=await api(p,true);
   if(!e.edit){D.pages[t]={err:JSON.stringify(e.error).slice(0,120)};save();continue}
   const pr=await api({action:'parse',page:t,prop:'text|templates'});
   const h=pr.parse.text;
   const reds=[...h.matchAll(/class="new"[^>]*title="([^"]+)"/g)].map(m=>m[1].replace(/ \(הדף אינו קיים\)$/,''));
   D.pages[t]={rev:e.edit.newrevid,errs:(h.match(/class="[^"]*(error|cite-error)[^"]*"/g)||[]).length,missingTpl:pr.parse.templates.filter(x=>!x.exists).map(x=>x.title),red:reds,over:c!==null};
  }catch(x){D.pages[t]={exc:String(x).slice(0,120)}}
  save()}
 // 4. redirects
 for(const [s,t] of (Array.isArray(red)?red:Object.entries(red))){if(D.redir[s])continue;
  const c=await cur(s); if(c!==null){D.redir[s]='EXISTS';continue}
  const e=await api({action:'edit',title:s,text:'#הפניה [['+t+']]',summary:'הפניה: [['+t+']]',createonly:'1',token:await T()},true);
  D.redir[s]=e.edit?'ok':JSON.stringify(e.error).slice(0,100); save()}
 D.done=true; save()};
