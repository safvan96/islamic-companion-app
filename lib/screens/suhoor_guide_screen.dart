import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}
class SuhoorGuideScreen extends StatelessWidget{const SuhoorGuideScreen({super.key});
  @override Widget build(BuildContext context){final p=_P.of(Provider.of<AppProvider>(context).isDarkMode);final l=AppLocalizations.of(context)!;
    final tips=['sh_tip1','sh_tip2','sh_tip3','sh_tip4','sh_tip5'];
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('suhoorGuide'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.accent.withOpacity(0.08),borderRadius:BorderRadius.circular(14)),
          child:Text(l.translate('suhoorInfo'),style:TextStyle(fontSize:12,color:p.muted,height:1.5))),
        const SizedBox(height:16),
        ...tips.asMap().entries.map((e)=>Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(12),border:Border.all(color:p.divider)),
          child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(Icons.check_circle_outline,size:18,color:p.accent),const SizedBox(width:10),Expanded(child:Text(l.translate(e.value),style:TextStyle(fontSize:13,color:p.fg,height:1.5)))]))),
      ]));}}
