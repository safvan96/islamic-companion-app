import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

const _attrs=[
  ('\u0627\u0644\u0648\u062c\u0648\u062f','Existence','aa_1_d'),('\u0627\u0644\u0642\u062f\u0645','Eternity','aa_2_d'),
  ('\u0627\u0644\u0628\u0642\u0627\u0621','Everlasting','aa_3_d'),('\u0627\u0644\u0648\u062d\u062f\u0627\u0646\u064a\u0629','Oneness','aa_4_d'),
  ('\u0627\u0644\u0642\u062f\u0631\u0629','Power','aa_5_d'),('\u0627\u0644\u0625\u0631\u0627\u062f\u0629','Will','aa_6_d'),
  ('\u0627\u0644\u0639\u0644\u0645','Knowledge','aa_7_d'),('\u0627\u0644\u062d\u064a\u0627\u0629','Life','aa_8_d'),
  ('\u0627\u0644\u0633\u0645\u0639','Hearing','aa_9_d'),('\u0627\u0644\u0628\u0635\u0631','Sight','aa_10_d'),
  ('\u0627\u0644\u0643\u0644\u0627\u0645','Speech','aa_11_d'),('\u0627\u0644\u062a\u0643\u0648\u064a\u0646','Creating','aa_12_d'),
  ('\u0645\u062e\u0627\u0644\u0641\u0629 \u0644\u0644\u062d\u0648\u0627\u062f\u062b','Unlike creation','aa_13_d'),
];
class AllahAttributesScreen extends StatelessWidget{const AllahAttributesScreen({super.key});
  @override Widget build(BuildContext context){final p=_P.of(Provider.of<AppProvider>(context).isDarkMode);final l=AppLocalizations.of(context)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('allahAttributes'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView.builder(padding:const EdgeInsets.fromLTRB(20,0,20,32),itemCount:_attrs.length,itemBuilder:(_,i){final(arabic,name,descKey)=_attrs[i];
        return Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(14),border:Border.all(color:p.divider)),
          child:Row(children:[Container(width:40,height:40,decoration:BoxDecoration(shape:BoxShape.circle,color:p.gold.withOpacity(0.12)),
            child:Center(child:Text(arabic,textDirection:TextDirection.rtl,style:TextStyle(fontSize:14,color:p.gold)))),
            const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(name,style:TextStyle(fontSize:15,fontWeight:FontWeight.w600,color:p.fg)),
              Text(l.translate(descKey),style:TextStyle(fontSize:11,color:p.muted,height:1.4))]))]));
      }));}}
