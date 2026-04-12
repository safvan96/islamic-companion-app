import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

const _examDuas=[
  ('\u0631\u0628 \u0627\u0634\u0631\u062d \u0644\u064a \u0635\u062f\u0631\u064a \u0648\u064a\u0633\u0631 \u0644\u064a \u0623\u0645\u0631\u064a','ed_1','20:25-26'),
  ('\u0631\u0628 \u0632\u062f\u0646\u064a \u0639\u0644\u0645\u0627','ed_2','20:114'),
  ('\u0627\u0644\u0644\u0647\u0645 \u0644\u0627 \u0633\u0647\u0644 \u0625\u0644\u0627 \u0645\u0627 \u062c\u0639\u0644\u062a\u0647 \u0633\u0647\u0644\u0627','ed_3','Hadith'),
  ('\u0627\u0644\u0644\u0647\u0645 \u0627\u0646\u0641\u0639\u0646\u064a \u0628\u0645\u0627 \u0639\u0644\u0645\u062a\u0646\u064a','ed_4','Hadith'),
];
class ExamDuasScreen extends StatelessWidget{const ExamDuasScreen({super.key});
  @override Widget build(BuildContext context){final p=_P.of(Provider.of<AppProvider>(context).isDarkMode);final l=AppLocalizations.of(context)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('examDuas'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.accent.withOpacity(0.08),borderRadius:BorderRadius.circular(14)),
          child:Text(l.translate('examDuasInfo'),style:TextStyle(fontSize:12,color:p.muted,height:1.5))),
        const SizedBox(height:16),
        ..._examDuas.map((d){final(arabic,transKey,ref)=d;return Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(14),border:Border.all(color:p.divider)),
          child:Column(children:[Row(mainAxisAlignment:MainAxisAlignment.end,children:[Container(padding:const EdgeInsets.symmetric(horizontal:6,vertical:2),decoration:BoxDecoration(color:p.gold.withOpacity(0.15),borderRadius:BorderRadius.circular(6)),child:Text(ref,style:TextStyle(fontSize:10,fontWeight:FontWeight.w600,color:p.gold)))]),
            const SizedBox(height:8),Text(arabic,textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:20,color:p.fg,height:1.8)),const SizedBox(height:10),
            Text(l.translate(transKey),textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:p.muted,fontStyle:FontStyle.italic,height:1.4))]));
        }),
      ]));}}
