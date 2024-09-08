﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ДокументыВыбраныКорректно(ВыбранныеОснования, ТипОснованияАктаОРасхождении) Экспорт
	//++ Локализация
	Если ТипОснованияАктаОРасхождении <> Перечисления.ТипыОснованияАктаОРасхождении.ПриобретениеТоваровУслуг
		Или ТипОснованияАктаОРасхождении <> Перечисления.ТипыОснованияАктаОРасхождении.РеализацияТоваровУслуг
		Или ТипОснованияАктаОРасхождении <> Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента  Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ДокументыУчаствующиеВЭДО = Новый Массив;
	
	Для Каждого ВыбранноеОснование Из ВыбранныеОснования Цикл
		
		Если ДокументУчаствуетВЭДО(ВыбранноеОснование) Тогда
			
			ДокументыУчаствующиеВЭДО.Добавить(ВыбранноеОснование);
		
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДокументыУчаствующиеВЭДО.Количество() > 0 Тогда
		
			КоличествоОснований = ВыбранныеОснования.Количество();
			СтрокаУчаствует = ?(ДокументыУчаствующиеВЭДО.Количество() = 1, НСтр("ru = 'участвует'"),НСтр("ru = 'участвуют'"));
			
			СтрокаДокументы = "";
			Для Каждого Документ Из ДокументыУчаствующиеВЭДО Цикл
				СтрокаДокументы = СтрокаДокументы + ?(ПустаяСтрока(СтрокаДокументы), "", ", ") + Строка(Документ);
			КонецЦикла;
			СтрокаДокументы = СтрокаДокументы + ".";
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Выбор нескольких документов-оснований доступен только если ни один из них не участвует в электронном документообороте.
											|Выбрано оснований - %1, в ЭДО %2 - %3.'"), КоличествоОснований, СтрокаУчаствует, СтрокаДокументы);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			Возврат Ложь;
		
	КонецЕсли;
	//-- Локализация
	Возврат Истина;
	
КонецФункции

Процедура ОпределитьДоступныеСпособыОтработкиАктаВЗависимостиОтСостоянияДокументаЭДО(Форма) Экспорт
	//++ Локализация
	Форма.ДоступныеСпособыОтработкиАктаПоСостояниюЭДО.Очистить();
	Форма.ДоступныеСпособыОтработкиАкта.Очистить();
	Форма.СтатусЭДООснования = "";

	Если РасхожденияКлиентСервер.ТипОснованияРеализацияТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении) Тогда
		
		ОпределитьДоступныеСпособыОтработкиАктаПоРеализации(Форма);
		
	ИначеЕсли РасхожденияКлиентСервер.ТипОснованияПриобретениеТоваровУслуг(Форма.Объект.ТипОснованияАктаОРасхождении) Тогда
		
		ОпределитьДоступныеСпособыОтработкиАктаПоПриобретению(Форма);
		
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

Процедура ДополнитьСтрокуТаблицыДействий(НоваяСтрока, ВыборкаОснования) Экспорт
	//++ Локализация
	Если Метаданные.ОпределяемыеТипы.ОснованияЭлектронныхДокументовЭДО.Тип.ПривестиЗначение(ВыборкаОснования.Основание) = ВыборкаОснования.Основание Тогда
		ДанныеЭДО = ОбменСКонтрагентами.СтатусДокументооборота(ВыборкаОснования.Основание);
		НоваяСтрока.СтатусЭДО           = ДанныеЭДО.Статус;
		НоваяСтрока.ЭлектронныйДокумент = ДанныеЭДО.ЭлектронныйДокумент
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

Процедура РаботаСАктамиОРасхождениях_ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	//++ Локализация
	Форма.ЕстьПравоОбменаЭДО = ОбменСКонтрагентами.ЕстьПравоВыполненияОбмена();
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

Функция ДокументУчаствуетВЭДО(Документ)

	Если Метаданные.ОпределяемыеТипы.ОснованияЭлектронныхДокументовЭДО.Тип.ПривестиЗначение(Документ) = Документ 
		 ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ЭлектронныйДокументВходящийЭДО")
			ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящийЭДО") Тогда
				
		СтатусДокументооборота = ОбменСКонтрагентами.СтатусДокументооборота(Документ).Статус;
	Иначе
		
		Возврат Ложь;
	
	КонецЕсли;	
	
	Если СтатусДокументооборота = "ЭДОНеНастроен"
		Или СтатусДокументооборота = "НеНачат"
		Или СтатусДокументооборота = "Ошибка" Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

#Область РаботаСЭДО

Процедура ОпределитьДоступныеСпособыОтработкиАктаПоПриобретению(Форма)
	
	Если Форма.ДокументыОснования.Количество() <> 1 Тогда
		
		РасхожденияСервер.ДобавитьВсеВозможныеСпособыОтработкиАктаПоПриобретению(Форма);
		
	Иначе
		
		Форма.СтатусЭДООснования = ОбменСКонтрагентами.СтатусДокументооборота(Форма.ДокументыОснования[0].Реализация).Статус;
		
		Если Форма.СтатусЭДООснования = "Отклонен" Тогда
			
			РасхожденияСервер.ДобавитьСпособыОтработкиАктаПоПриобретениюИсправление(Форма);
			
		ИначеЕсли Форма.СтатусЭДООснования = "Утвержден" Тогда
			
			РасхожденияСервер.ДобавитьСпособыОтработкиАктаПоПриобретениюКорректировка(Форма);
			
		Иначе
			
			РасхожденияСервер.ДобавитьВсеВозможныеСпособыОтработкиАктаПоПриобретению(Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьДоступныеСпособыОтработкиАктаПоРеализации(Форма)
	
	Если Форма.ДокументыОснования.Количество() <> 1 Тогда
		
		РасхожденияСервер.ДобавитьВсеВозможныеСпособыОтработкиАктаПоРеализации(Форма);
		
	Иначе
		
		Форма.СтатусЭДООснования = ОбменСКонтрагентами.СтатусДокументооборота(Форма.ДокументыОснования[0].Реализация).Статус;
		
		Если Форма.СтатусЭДООснования = "ЭДОНеНастроен"
			Или Форма.СтатусЭДООснования = "НеНачат"
			Или Форма.СтатусЭДООснования = "Ошибка" Тогда
		
			РасхожденияСервер.ДобавитьВсеВозможныеСпособыОтработкиАктаПоРеализации(Форма);
			
		ИначеЕсли Форма.СтатусЭДООснования = "Отклонен" Тогда
			
			Форма.ДоступныеСпособыОтработкиАктаПоСостояниюЭДО.Добавить(Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ИсправлениеПервичныхДокументов);
			Форма.ДоступныеСпособыОтработкиАкта.Добавить(Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ИсправлениеПервичныхДокументов);
			
		ИначеЕсли Форма.СтатусЭДООснования = "Утвержден" Тогда
			
			Форма.ДоступныеСпособыОтработкиАктаПоСостояниюЭДО.Добавить(Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиКакИсправлениеПервичныхДокументов);
			Форма.ДоступныеСпособыОтработкиАктаПоСостояниюЭДО.Добавить(Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиПоСогласованию);
			Форма.ДоступныеСпособыОтработкиАкта.Добавить(Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировокКакНовыеПервичныеДокументы);
			
			РасхожденияСервер.ДобавитьСпособыОтработкиКорректировкаРеализации(Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- Локализация

#КонецОбласти