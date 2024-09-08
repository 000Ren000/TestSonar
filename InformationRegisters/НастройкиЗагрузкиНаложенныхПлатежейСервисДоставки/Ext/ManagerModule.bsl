﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьЗапись(Параметры, Отказ = Ложь) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиЗагрузкиНаложенныхПлатежейСервисДоставки");
		ЭлементБлокировки.УстановитьЗначение("Перевозчик", Параметры.Перевозчик);
		ЭлементБлокировки.УстановитьЗначение("Организация", Параметры.Организация);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.НастройкиЗагрузкиНаложенныхПлатежейСервисДоставки.СоздатьМенеджерЗаписи();
		Запись.Перевозчик = Параметры.Перевозчик;
		Запись.Организация = Параметры.Организация;
		Запись.Прочитать();
		
		Если Запись.Выбран() Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В списке уже есть договор %1 для организации %2 и перевозчика %3.
				|Небходимо вначале удалить этот договор из списка.'", ОбщегоНазначения.КодОсновногоЯзыка()),
				Запись.ДоговорЭквайринга,
				Запись.Перевозчик,
				Запись.Организация));
				
			ОтменитьТранзакцию();
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Запись, Параметры);
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Отказ = Истина;
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Сервис доставки.Добавление договора эквайринга.'",ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
			
		ОбщегоНазначения.СообщитьПользователю(ИнформацияОбОшибке().Описание);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли