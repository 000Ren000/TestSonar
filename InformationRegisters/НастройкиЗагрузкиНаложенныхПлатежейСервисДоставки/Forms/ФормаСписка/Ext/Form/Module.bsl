﻿#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ДоговорЭквайринга = ТекущиеДанные.ДоговорЭквайринга;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", ДоговорЭквайринга);
	
	ОткрытьФорму("Справочник.ДоговорыЭквайринга.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДоговорЭквайринга(Команда)
	
	ОткрытьФорму("Справочник.ДоговорыЭквайринга.ФормаВыбора",,ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ДобавитьДоговорЭквайрингаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДоговорЭквайрингаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Отказ = Ложь;
		ДобавитьДоговорЭквайрингаСервер(Результат, Отказ);
		Если Не Отказ Тогда
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьДоговорЭквайрингаСервер(ДоговорЭквайринга, Отказ)
	
	Если ДоговорЭквайринга <> Справочники.ДоговорыЭквайринга.ПустаяСсылка() Тогда
		
		ПараметрыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорЭквайринга,
			"Организация, Контрагент, ИспользуютсяЭквайринговыеТерминалы");
		
		ТекстСообщения = "";
		Если ПараметрыДоговора.ИспользуютсяЭквайринговыеТерминалы Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru='В договоре необходимо указать, что платежи проводятся через Интернет-эквайринг.'", ОбщегоНазначения.КодОсновногоЯзыка());
		Иначе
			
			Отказ = Ложь;
			Если ПараметрыДоговора.Организация = Справочники.Организации.ПустаяСсылка() Тогда
				ТекстСообщения = НСтр("ru='В договоре необходимо указать организацию.'", ОбщегоНазначения.КодОсновногоЯзыка());
				Отказ = Истина;
			КонецЕсли;
			
			Если ПараметрыДоговора.Контрагент = Справочники.Контрагенты.ПустаяСсылка() Тогда
				ТекстСообщения = ТекстСообщения + Символы.ПС
					+ НСтр("ru='В договоре необходимо указать контрагента (перевозчика).'", ОбщегоНазначения.КодОсновногоЯзыка());
				Отказ = Истина;
			КонецЕсли;
			ТекстСообщения = СокрЛП(ТекстСообщения);
			
		КонецЕсли;
		
		Если Отказ Тогда
			ТекстОшибки = НСтр("ru='Выбран некорректный договор подключения.'", ОбщегоНазначения.КодОсновногоЯзыка());
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки + Символы.ПС + ТекстСообщения);
		Иначе
			ПараметрыЗаписи = Новый Структура();
			ПараметрыЗаписи.Вставить("ДоговорЭквайринга", ДоговорЭквайринга);
			ПараметрыЗаписи.Вставить("Перевозчик", ПараметрыДоговора.Контрагент);
			ПараметрыЗаписи.Вставить("Организация", ПараметрыДоговора.Организация);
			РегистрыСведений.НастройкиЗагрузкиНаложенныхПлатежейСервисДоставки.ДобавитьЗапись(ПараметрыЗаписи, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
