﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
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

&НаКлиенте
Процедура ТитулПеревозчикаВодителиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = Неопределено;
		ТекущиеДанные.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеВодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулПеревозчикаВодители.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеВодительПриИзменении(Элемент)
	
	ЗначениеРеквизита = Элементы.ТитулПеревозчикаВодители.ТекущиеДанные.ХранимыеДанныеВодитель;
	Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		ВходящийКонтекст = Новый Структура;
		ВходящийКонтекст.Вставить("ЗапретитьИзменение", Ложь);
		ВходящийКонтекст.Вставить("Форма", ЭтотОбъект);
		ВходящийКонтекст.Вставить("ГруппаДанных", СтрЗаменить(Элемент.Имя, "ХранимыеДанные", ""));
		ВходящийКонтекст.Вставить("ТекущиеДанные", Элементы.ТитулПеревозчикаВодители.ТекущиеДанные);
		ОбменСГИСЭПДКлиент.ОткрытиеФормыПоГиперссылке_Завершение(ЗначениеРеквизита, ВходящийКонтекст);	
	Иначе
		ОбменСГИСЭПДКлиентСервер.ИзменитьОформлениеЭлементовФормы(ЭтотОбъект, СтрЗаменить(Элемент.Имя, "ХранимыеДанные", ""));	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеВодительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ГруппаДанных = СтрЗаменить(Элемент.Имя, "ХранимыеДанные", "");
	ПараметрыПолученияДанных.Отбор = ОбменСГИСЭПДКлиент.ПолучитьОтборХранимыхДанных(ЭтотОбъект, ЭтотОбъект, ГруппаДанных);
	ПараметрыПолученияДанных.СпособПоискаСтроки = ПредопределенноеЗначение("СпособПоискаСтрокиПриВводеПоСтроке.ЛюбаяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулПеревозчикаВодителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);


КонецПроцедуры