﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ТипГрафика") Тогда
		ТипГрафика = Параметры.ТипГрафика;
		ИнициализироватьПараметрыЗагрузки();
	КонецЕсли;
	
	Параметры.Свойство("ВариантГрафика", ВариантГрафика);
	Параметры.Свойство("ИдентификаторВладельца", ИдентификаторВладельца);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьГрафик(Команда)
	
	ВыполнитьЗагрузкуГрафика();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ВыполнитьЗагрузкуГрафика()
	
	Если ЗагрузитьГрафикСервер() Тогда
		Закрыть(АдресГрафика);
	КонецЕсли;
	
	Текст = НСтр("ru = 'Загрузка окончена'");
	ПоказатьОповещениеПользователя(Текст,,, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура СообщитьОбОшибкеПреобразования(НомерСтроки, ИмяКолонки, СтроковоеЗначение)
	
	ШаблонТекста = НСтр("ru='Строка №%1 колонка ""%2"" - ошибка преобразования значения ""%3""
		|Строка не загружена!'");
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, НомерСтроки, ИмяКолонки, СтроковоеЗначение);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	
КонецПроцедуры

&НаСервере
Функция ТекстВДату(Знач СтроковоеЗначение, НомерСтроки, ИмяКолонки, Разделитель = ".")
	
	Цифры = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтроковоеЗначение,Разделитель);
	
	Попытка
		Результат = ?(СтрДлина(Цифры[2]) = 2, "20" + Цифры[2], Цифры[2])
			+ Формат(Цифры[1], "ЧЦ=2; ЧВН=;") 
			+ Формат(Цифры[0], "ЧЦ=2; ЧВН=;");
		Результат = Дата(Результат);
	Исключение
		СообщитьОбОшибкеПреобразования(НомерСтроки, ИмяКолонки, СтроковоеЗначение);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ТекстВЧисло(СтроковоеЗначение, НомерСтроки, ИмяКолонки)
	
	Если ПустаяСтрока(СтроковоеЗначение) ИЛИ СтроковоеЗначение = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Попытка
		Результат = Число(СтрЗаменить(СтроковоеЗначение," ",""));
	Исключение
		СообщитьОбОшибкеПреобразования(НомерСтроки, ИмяКолонки, СтроковоеЗначение);
	КонецПопытки;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗагрузитьГрафикСервер()
	
	НомерСтроки = 2;
	СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
	ПоляЗагрузки = ПараметрыЗагрузки.Поля;
	ЗаполненаДата = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + СтроковыйНомер + ПоляЗагрузки.Период).Текст);
	ЗагруженоБезОшибок = Истина;
	
	// Подготовим набор записей
	ЗаписиГрафика = РегистрыСведений[ПараметрыЗагрузки.ИмяРегистра].СоздатьНаборЗаписей(); // РегистрСведенийНаборЗаписей
	ЗаписиГрафика.Отбор.ВариантГрафика.Установить(ВариантГрафика);
	
	Пока ЗаполненаДата Цикл
		
		ДанныеСтроки = Неопределено;
		Попытка
			// Прочитаем данные строки графика
			ДанныеСтроки = Новый Структура("ВариантГрафика",ВариантГрафика);
			Для Каждого Поле Из ПоляЗагрузки Цикл
				
				ТекстЗначения = ТабличныйДокумент.Область("R" + СтроковыйНомер + Поле.Значение).Текст;
				Если Поле.Ключ = "Период" Тогда
					ЗначениеПоля = ТекстВДату(ТекстЗначения, СтроковыйНомер, Поле.Ключ);
				Иначе
					ЗначениеПоля = ТекстВЧисло(ТекстЗначения, СтроковыйНомер, Поле.Ключ);
				КонецЕсли;
				ДанныеСтроки.Вставить(Поле.Ключ,ЗначениеПоля);
				
			КонецЦикла;// по колонкам таблицы загрузки
			
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если ЗначениеЗаполнено(ДанныеСтроки) Тогда
			// Проверим все что прочитали
			ВсеПоляЗаполнены = ЗначениеЗаполнено(ДанныеСтроки.Период);
			Если ВсеПоляЗаполнены Тогда
				СуммаПолей = 0;
				Для Каждого Поле Из ПараметрыЗагрузки.ПоляКонтроля Цикл
					СуммаПолей = СуммаПолей + ДанныеСтроки[Поле];
				КонецЦикла;// по контрольным полям
				Если СуммаПолей = 0 Тогда
					ВсеПоляЗаполнены = Ложь;
					ЗагруженоБезОшибок = Ложь;
					ШаблонТекста = НСтр("ru='В строке №%1 нет заполненных колонок сумм.
						|Строка не загружена!'");
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, СтроковыйНомер);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
				КонецЕсли;
			КонецЕсли;
			
			// Запишем прочитанное
			Если ВсеПоляЗаполнены Тогда
				НоваяЗапись = ЗаписиГрафика.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ДанныеСтроки);
			КонецЕсли;
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		СтроковыйНомер = Формат(НомерСтроки, "ЧН=0; ЧГ=0");
		
		Попытка
			ЗаполненаДата = ЗначениеЗаполнено(ТабличныйДокумент.Область("R" + СтроковыйНомер + ПоляЗагрузки.Период).Текст);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;// по строкам таблицы загрузки
	
	АдресГрафика = ПоместитьВоВременноеХранилище(ОбщегоНазначения.ЗначениеВСтрокуXML(ЗаписиГрафика), ИдентификаторВладельца);
	
	Возврат ЗагруженоБезОшибок;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьПараметрыЗагрузки()
	
	ПараметрыЗагрузки = Новый Структура;
	ПоляЗагрузки = Новый Структура("Период","C1");
	Если ТипГрафика = "ГрафикНачислений" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Загрузка графика начислений'");
		
		ПоляЗагрузки.Вставить("Проценты","C2");
		ПоляЗагрузки.Вставить("Комиссия","C3");
		
		МассивПолей = Новый Массив;
		МассивПолей.Добавить("Проценты");
		МассивПолей.Добавить("Комиссия");
		
		ПараметрыЗагрузки.Вставить("ПоляКонтроля", МассивПолей);
		ПараметрыЗагрузки.Вставить("ИмяРегистра", "ГрафикНачисленийКредитовИДепозитов");
		
	ИначеЕсли ТипГрафика = "ГрафикОплат" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Загрузка графика оплат'");
		ПоляЗагрузки.Вставить("Сумма","C2");
		ПоляЗагрузки.Вставить("Проценты","C3");
		ПоляЗагрузки.Вставить("Комиссия","C4");
		
		МассивПолей = Новый Массив;
		МассивПолей.Добавить("Сумма");
		МассивПолей.Добавить("Проценты");
		МассивПолей.Добавить("Комиссия");
		
		ПараметрыЗагрузки.Вставить("ПоляКонтроля", МассивПолей);
		ПараметрыЗагрузки.Вставить("ИмяРегистра", "ГрафикОплатКредитовИДепозитов");
		
	ИначеЕсли ТипГрафика = "ГрафикТраншей" Тогда
		
		ЭтаФорма.Заголовок = НСтр("ru = 'Загрузка графика траншей'");
		ПоляЗагрузки.Вставить("Сумма","C2");
		
		МассивПолей = Новый Массив;
		МассивПолей.Добавить("Сумма");
		
		ПараметрыЗагрузки.Вставить("ПоляКонтроля", МассивПолей);
		ПараметрыЗагрузки.Вставить("ИмяРегистра", "ГрафикТраншейКредитовИДепозитов");
		
	КонецЕсли;
	
	ПараметрыЗагрузки.Вставить("Поля", ПоляЗагрузки);
	
	// Инициализируем табличный документ
	МакетШаблона = Справочники.ВариантыГрафиковКредитовИДепозитов.ПолучитьМакет("МакетЗагрузкиГрафиков");
	ТабличныйДокумент.Очистить();
	ОбластьКолонки = МакетШаблона.ПолучитьОбласть(ТипГрафика);
	ТабличныйДокумент.Присоединить(ОбластьКолонки);
	ТабличныйДокумент.ФиксацияСверху = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
