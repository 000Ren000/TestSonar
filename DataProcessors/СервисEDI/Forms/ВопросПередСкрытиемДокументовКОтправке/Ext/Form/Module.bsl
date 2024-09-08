﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСкрытие(Команда)
	
	Если БольшеНеПоказывать Тогда
		СохранитьПризнакНеПоказыватьВНастройках();
	КонецЕсли;
	
	Закрыть(КодВозвратаДиалога.ОК)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьПризнакНеПоказыватьВНастройках()

	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить("СервисEDI.ВопросПередСкрытиемДокументовКОтправке", "НеПоказывать", Истина);

КонецПроцедуры

#КонецОбласти

