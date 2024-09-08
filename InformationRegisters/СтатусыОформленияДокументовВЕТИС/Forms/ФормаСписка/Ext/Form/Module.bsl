﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьДанныеДляРасчетаСтатуса(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не выбрана строка списка.'"));
		Возврат;
	КонецЕсли;
	
	ТабДок = ПолучитьДанныеДляРасчетаСтатуса();
	
	Если ТабДок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТабДок.Показать(ТекущиеДанные.Основание);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДанныеДляРасчетаСтатуса()
	
	МенеджерЗаписи = РегистрыСведений.СтатусыОформленияДокументовВЕТИС.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Элементы.Список.ТекущаяСтрока);
	
	МенеджерЗаписи.Прочитать();
	
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Невозможно получить данные, использованные при расчете статуса.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(МенеджерЗаписи.ДополнительнаяИнформация) <> Тип("ХранилищеЗначения") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Невозможно получить данные, использованные при расчете статуса.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаДляРасчетаСтатуса = МенеджерЗаписи.ДополнительнаяИнформация.Получить();
	
	Если ТипЗнч(ТаблицаДляРасчетаСтатуса) <> Тип("ТаблицаЗначений") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Невозможно получить данные, использованные при расчете статуса.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ТабДок = ПреобразоватьТаблицуЗначенийВТабличныйДокумент(ТаблицаДляРасчетаСтатуса);
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Функция ПреобразоватьТаблицуЗначенийВТабличныйДокумент(Таблица)
	
	ТабДок = Новый ТабличныйДокумент; // преобразованная в mxl таблица значений
	
	НомерСтроки  = 1;
	НомерКолонки = 0;
	
	// Сформируем шапку табличного документа - выведем имена колонок таблицы значений
	Для Каждого ТекКолонка Из Таблица.Колонки Цикл
		
		НомерКолонки = НомерКолонки + 1;
		
		Область = ТабДок.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
		Область.Текст 		 = ?(ЗначениеЗаполнено(ТекКолонка.Заголовок), ТекКолонка.Заголовок, ТекКолонка.Имя);
		Область.Шрифт 		 = Новый Шрифт(Область.Шрифт,,, Истина); 
		Область.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
		
	КонецЦикла;
	
	// Выведем строки таблицы значений
	Для Каждого ТекСтр Из Таблица Цикл
		
		НомерСтроки = НомерСтроки + 1;
		НомерКолонки = 0;
		
		Для Каждого ТекКолонка Из Таблица.Колонки Цикл
			
			НомерКолонки = НомерКолонки + 1;
			
			Область = ТабДок.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			Область.Текст = ТекСтр[ТекКолонка.Имя];
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТабДок.ФиксацияСверху = 1;
	ТабДок.ФиксацияСлева  = 1;
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти
