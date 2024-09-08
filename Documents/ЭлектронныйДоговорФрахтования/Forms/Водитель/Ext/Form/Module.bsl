﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, "ТитулФрахтовщикаКонтактыВодителяАдресаЭлектроннойПочты", "АдресЭлектроннойПочты");
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, "ТитулФрахтовщикаКонтактыВодителяНомераТелефонов", "Телефон");
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДобавлениеПоляВвода(Команда)
	
	ИмяТаблицыИПоля = СтрЗаменить(Команда.Имя, "ДобавлениеПоляВвода", "");
	МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(ИмяТаблицыИПоля, "__");
	
	ДобавлениеПоляВводаСервер(МассивЧастей[0], МассивЧастей[1]);
	
КонецПроцедуры

&НаСервере
Процедура ДобавлениеПоляВводаСервер(ИмяТаблицы, ИмяПоля)
	
	ОбменСГИСЭПД.СоздатьЭлементыВводаЗначенийСписка(ЭтотОбъект, ИмяТаблицы, ИмяПоля, Истина);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПолеЗначенияСпискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(Элемент.Имя, "__");	
	УстановитьФорматированноеЗначениеПоляВвода(МассивЧастей[0], МассивЧастей[1], Число(МассивЧастей[2]), Текст);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФорматированноеЗначениеПоляВвода(ИмяТаблицы, ИмяПоля, НомерСтроки, Текст)
	
	ТекущиеДанные = ЭтотОбъект[ИмяТаблицы][НомерСтроки];	 
	ОбменСГИСЭПД.УстановитьФорматированноеЗначениеПоляВвода(ЭтотОбъект, ТекущиеДанные, ИмяПоля, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулФрахтовщикаКонтактыВодителяАдресаЭлектроннойПочтыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = Неопределено;
		ТекущиеДанные.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТитулФрахтовщикаКонтактыВодителяНомераТелефоновПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = Неопределено;
		ТекущиеДанные.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТитулФрахтовщикаКонтактыВодителяАдресаЭлектроннойПочтыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);


КонецПроцедуры

&НаКлиенте
Процедура ТитулФрахтовщикаКонтактыВодителяНомераТелефоновПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);


КонецПроцедуры