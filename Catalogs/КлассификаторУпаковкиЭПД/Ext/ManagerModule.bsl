﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ТаблицаКлассификатораУпаковки() Экспорт
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	
	Макет = Справочники.КлассификаторУпаковкиЭПД.ПолучитьМакет("КлассификаторУпаковки");
	Список = Макет.Области.Найти("Строки");
	
	Если Список.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		// Заполнение дерева данными списка.
		ВерхОбласти = Список.Верх;
		НизОбласти = Список.Низ;
		
		НомерКолонки = 1;
		Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
		ИмяКолонки = Область.Текст;
		
		Пока ЗначениеЗаполнено(ИмяКолонки) Цикл
			
			Если ИмяКолонки = "Код" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(2)));
			ИначеЕсли ИмяКолонки = "Наименование" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(250)));
			ИначеЕсли ИмяКолонки = "НаименованиеНаАнглийском" Тогда
				ТаблицаПоказателей.Колонки.Добавить("НаименованиеНаАнглийском", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(250)));
			КонецЕсли;
			
			НомерКолонки = НомерКолонки + 1;
			Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
			ИмяКолонки = Область.Текст;
			
		КонецЦикла;
		
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			// Отображаем только элементы
			
			Код = СокрП(Макет.Область(НомСтр, 1).Текст);
			Если СтрДлина(Код) <> 2 Тогда
				Продолжить;
			КонецЕсли;
			СтрокаСписка = ТаблицаПоказателей.Добавить();
			
			Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
				
				ЗначениеКолонки = СокрП(Макет.Область(НомСтр, ТаблицаПоказателей.Колонки.Индекс(Колонка) + 1).Текст);
				СтрокаСписка[Колонка.Имя] = ЗначениеКолонки;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПоказателей.Сортировать(ТаблицаПоказателей.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

#КонецЕсли

