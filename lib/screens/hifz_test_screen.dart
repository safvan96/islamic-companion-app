import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}
const _qs=[('\u0628\u0633\u0645 \u0627\u0644\u0644\u0647 \u0627\u0644\u0631\u062d\u0645\u0646 \u0627\u0644\u0631\u062d\u064a\u0645 \u0627\u0644\u062d\u0645\u062f \u0644\u0644\u0647 \u0631\u0628 \u0627\u0644\u0639\u0627\u0644\u0645\u064a\u0646','Al-Fatiha',['Al-Baqarah','Al-Fatiha','Al-Ikhlas','An-Nas'],1),
  ('\u0642\u0644 \u0647\u0648 \u0627\u0644\u0644\u0647 \u0623\u062d\u062f','Al-Ikhlas',['Al-Falaq','An-Nas','Al-Ikhlas','Al-Fatiha'],2),
  ('\u0642\u0644 \u0623\u0639\u0648\u0630 \u0628\u0631\u0628 \u0627\u0644\u0641\u0644\u0642','Al-Falaq',['An-Nas','Al-Ikhlas','Al-Falaq','Al-Kafirun'],2),
  ('\u0625\u0646\u0627 \u0623\u0639\u0637\u064a\u0646\u0627\u0643 \u0627\u0644\u0643\u0648\u062b\u0631','Al-Kawthar',['An-Nasr','Al-Kawthar','Al-Asr','Al-Fil'],1),
  ('\u0625\u0630\u0627 \u062c\u0627\u0621 \u0646\u0635\u0631 \u0627\u0644\u0644\u0647 \u0648\u0627\u0644\u0641\u062a\u062d','An-Nasr',['An-Nasr','Al-Masad','Al-Kafirun','Al-Falaq'],0),
  ('\u0648\u0627\u0644\u0639\u0635\u0631 \u0625\u0646 \u0627\u0644\u0625\u0646\u0633\u0627\u0646 \u0644\u0641\u064a \u062e\u0633\u0631','Al-Asr',['Al-Asr','Ad-Duha','At-Tin','Al-Qadr'],0),
  ('\u0623\u0644\u0645 \u0646\u0634\u0631\u062d \u0644\u0643 \u0635\u062f\u0631\u0643','Ash-Sharh',['Ad-Duha','Ash-Sharh','Al-Alaq','Al-Qadr'],1),
  ('\u0623\u0644\u0645 \u062a\u0631 \u0643\u064a\u0641 \u0641\u0639\u0644 \u0631\u0628\u0643 \u0628\u0623\u0635\u062d\u0627\u0628 \u0627\u0644\u0641\u064a\u0644','Al-Fil',['Quraysh','Al-Fil','Al-Masad','Al-Humazah'],1),
];
class HifzTestScreen extends StatefulWidget{const HifzTestScreen({super.key});@override State<HifzTestScreen>createState()=>_S();}
class _S extends State<HifzTestScreen>{late List<int>_order;int _cur=0,_score=0;int?_sel;bool _answered=false,_done=false;
  @override void initState(){super.initState();_start();}
  void _start(){final r=Random();_order=List.generate(_qs.length,(i)=>i)..shuffle(r);_order=_order.take(5).toList();_cur=0;_score=0;_sel=null;_answered=false;_done=false;setState((){});}
  void _pick(int i){if(_answered)return;HapticFeedback.lightImpact();setState((){_sel=i;_answered=true;if(i==_qs[_order[_cur]].$4)_score++;});
    Future.delayed(const Duration(milliseconds:1000),(){if(!mounted)return;if(_cur<_order.length-1) {
      setState((){_cur++;_sel=null;_answered=false;});
    } else {
      setState(()=>_done=true);
    }});}
  @override Widget build(BuildContext c){final isDark=Provider.of<AppProvider>(c).isDarkMode;final p=_P.of(isDark);final l=AppLocalizations.of(c)!;
    if(_done) {
      return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('hifzTest'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.check_circle,size:64,color:p.gold),const SizedBox(height:16),Text('$_score/${_order.length}',style:TextStyle(fontSize:40,fontWeight:FontWeight.w700,color:p.fg)),const SizedBox(height:24),ElevatedButton(onPressed:_start,style:ElevatedButton.styleFrom(backgroundColor:p.accent,foregroundColor:Colors.white,padding:const EdgeInsets.symmetric(horizontal:32,vertical:14),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))),child:Text(l.translate('playAgain'),style:const TextStyle(fontSize:15,fontWeight:FontWeight.w600)))])));
    }
    final q=_qs[_order[_cur]];
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('hifzTest'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Text('${_cur+1}/${_order.length}',style:TextStyle(fontSize:13,color:p.muted,fontWeight:FontWeight.w600)),const Spacer(),Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),decoration:BoxDecoration(color:p.gold.withOpacity(0.15),borderRadius:BorderRadius.circular(8)),child:Text('$_score',style:TextStyle(fontSize:13,color:p.gold,fontWeight:FontWeight.w700)))]),
        const SizedBox(height:20),
        Text(l.translate('pickSurah'),style:TextStyle(fontSize:13,color:p.muted)),
        const SizedBox(height:16),
        Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(16),border:Border.all(color:p.divider)),child:Text(q.$1,textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:22,color:p.fg,height:1.8))),
        const SizedBox(height:20),
        ...List.generate(q.$3.length,(i){final correct=i==q.$4;final selected=i==_sel;Color bc=p.divider,bg=p.surface;
          if(_answered){if(correct){bc=const Color(0xFF4CAF50);bg=const Color(0xFF4CAF50).withOpacity(0.1);}else if(selected){bc=const Color(0xFFE53935);bg=const Color(0xFFE53935).withOpacity(0.1);}}
          return Padding(padding:const EdgeInsets.only(bottom:8),child:InkWell(onTap:()=>_pick(i),borderRadius:BorderRadius.circular(12),child:Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(12),border:Border.all(color:bc,width:1.5)),child:Text(q.$3[i],style:TextStyle(fontSize:15,color:p.fg,fontWeight:FontWeight.w500)))));
        }),
      ])));
  }
}
