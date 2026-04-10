import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../services/hijri_calendar.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}
class BayramCountdownScreen extends StatelessWidget{const BayramCountdownScreen({super.key});
  @override Widget build(BuildContext c){final isDark=Provider.of<AppProvider>(c).isDarkMode;final p=_P.of(isDark);final l=AppLocalizations.of(c)!;final h=HijriCalendar.now();
    final events=[('Ramadan',9,1),('Eid al-Fitr',10,1),('Day of Arafah',12,9),('Eid al-Adha',12,10),('Islamic New Year',1,1),('Ashura',1,10)];
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('countdown'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:LinearGradient(colors:[p.gold.withOpacity(0.12),p.accent.withOpacity(0.06)]),borderRadius:BorderRadius.circular(20),border:Border.all(color:p.gold.withOpacity(0.2))),
          child:Column(children:[Text(l.translate('today'),style:TextStyle(fontSize:11,color:p.muted)),const SizedBox(height:4),Text(h.format(Localizations.localeOf(c).languageCode),style:TextStyle(fontSize:18,fontWeight:FontWeight.w600,color:p.fg))])),
        const SizedBox(height:20),
        ...events.map((e){final(name,m,d)=e;int days=((m-h.month)*30+(d-h.day));if(days<0)days+=354;
          return Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(12),border:Border.all(color:p.divider)),
            child:Row(children:[Container(width:48,height:48,decoration:BoxDecoration(shape:BoxShape.circle,color:p.gold.withOpacity(0.12)),child:Center(child:Text('$days',style:TextStyle(fontSize:18,fontWeight:FontWeight.w700,color:p.gold)))),
              const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(name,style:TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:p.fg)),Text('$d/$m ${l.translate('hijriLabel')}',style:TextStyle(fontSize:11,color:p.muted))])),
              Text('${l.translate('days')}',style:TextStyle(fontSize:11,color:p.muted))]));
        }),
      ]));
  }
}
