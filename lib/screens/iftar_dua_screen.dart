import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

const _iftarDua='\u0630\u0647\u0628 \u0627\u0644\u0638\u0645\u0623 \u0648\u0627\u0628\u062a\u0644\u062a \u0627\u0644\u0639\u0631\u0648\u0642 \u0648\u062b\u0628\u062a \u0627\u0644\u0623\u062c\u0631 \u0625\u0646 \u0634\u0627\u0621 \u0627\u0644\u0644\u0647';
const _suhoorDua='\u0648\u0628\u0635\u0648\u0645 \u063a\u062f \u0646\u0648\u064a\u062a \u0645\u0646 \u0634\u0647\u0631 \u0631\u0645\u0636\u0627\u0646';
class IftarDuaScreen extends StatelessWidget{const IftarDuaScreen({super.key});
  @override Widget build(BuildContext context){final p=_P.of(Provider.of<AppProvider>(context).isDarkMode);final l=AppLocalizations.of(context)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('iftarSuhoor'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        _duaCard(p,l,'IFTAR DUA',_iftarDua,'iftarDuaTrans',p.gold),
        const SizedBox(height:16),
        _duaCard(p,l,'SUHOOR DUA',_suhoorDua,'suhoorDuaTrans',p.accent),
        const SizedBox(height:16),
        Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.gold.withOpacity(0.08),borderRadius:BorderRadius.circular(14)),
          child:Row(children:[Icon(Icons.lightbulb,color:p.gold,size:16),const SizedBox(width:8),Expanded(child:Text(l.translate('iftarTip'),style:TextStyle(fontSize:12,color:p.muted,height:1.4)))])),
      ]));
  }
  Widget _duaCard(_P p,AppLocalizations l,String title,String arabic,String transKey,Color color)=>Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(16),border:Border.all(color:color.withOpacity(0.3))),
    child:Column(children:[Text(title,style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:color,letterSpacing:1.0)),const SizedBox(height:12),Text(arabic,textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:20,color:p.fg,height:1.8)),const SizedBox(height:10),Text(l.translate(transKey),textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:p.muted,fontStyle:FontStyle.italic,height:1.4)),
      const SizedBox(height:8),Row(mainAxisAlignment:MainAxisAlignment.center,children:[IconButton(onPressed:(){Clipboard.setData(ClipboardData(text:arabic));},icon:Icon(Icons.copy,size:16,color:p.muted)),IconButton(onPressed:()=>Share.share(arabic),icon:Icon(Icons.share_outlined,size:16,color:p.muted))])]));
}
