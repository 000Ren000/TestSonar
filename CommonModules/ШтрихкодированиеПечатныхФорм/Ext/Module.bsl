﻿
#Область ПрограммныйИнтерфейс

// Возвращает числовой код для печати штрихкода
//
//	Параметры:
//		Ссылка - ЛюбаяСсылка - ссылка на объект, по которому нужно получить код
//	Возвращаемое значение:
//		Строка - строка из чисел, соответствующая переданной ссылке.
//
Функция ЧисловойКодПоСсылке(Ссылка) Экспорт
	ШестнадцатиричноеЧисло = СтрЗаменить(Строка(Ссылка.УникальныйИдентификатор()),"-","");
	Возврат ПреобразоватьИзШестнадцатеричнойСистемыСчисленияВДесятичноеЧисло(ШестнадцатиричноеЧисло);
КонецФункции

// Функция - Получить ссылку по штрихкоду табличного документа
//
// Параметры:
//  Штрихкод - Строка - Штрихкод
//  Менеджеры - Массив из СправочникСсылка, ДокументСсылка, ЗадачаСсылка - Менеджеры документов.
// 
// Возвращаемое значение:
//  Массив - Ссылки на документы
//
Функция ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры = Неопределено) Экспорт
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Штрихкод, Ложь, Ложь)
		ИЛИ СокрЛП(Штрихкод) = "" Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	ШтрихкодВШестнадцатеричномВиде = ПреобразоватьДесятичноеЧислоВШестнадцатеричнуюСистемуСчисления(Число(Штрихкод));
	Пока СтрДлина(ШтрихкодВШестнадцатеричномВиде) < 32 Цикл
		ШтрихкодВШестнадцатеричномВиде = "0" + ШтрихкодВШестнадцатеричномВиде;
	КонецЦикла;
	
	Идентификатор =
	        Сред(ШтрихкодВШестнадцатеричномВиде, 1,  8)
	+ "-" + Сред(ШтрихкодВШестнадцатеричномВиде, 9,  4)
	+ "-" + Сред(ШтрихкодВШестнадцатеричномВиде, 13, 4)
	+ "-" + Сред(ШтрихкодВШестнадцатеричномВиде, 17, 4)
	+ "-" + Сред(ШтрихкодВШестнадцатеричномВиде, 21, 12);
	
	Если СтрДлина(Идентификатор) <> 36 Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Если Менеджеры = Неопределено Тогда
		МенеджерыОбъектов = Новый Массив();
		Для Каждого ЭлементМетаданных Из Метаданные.Документы Цикл
			МенеджерыОбъектов.Добавить(Документы[ЭлементМетаданных.Имя]);
		КонецЦикла;
	Иначе
		МенеджерыОбъектов = Новый Массив();
		Для Каждого ПустаяСсылка Из Менеджеры Цикл
			
			ТипСсылки = ТипЗнч(ПустаяСсылка);
			
			Если Документы.ТипВсеСсылки().СодержитТип(ТипСсылки) Тогда
				МенеджерыОбъектов.Добавить(Документы[ПустаяСсылка.Метаданные().Имя]);
				
			ИначеЕсли Справочники.ТипВсеСсылки().СодержитТип(ТипСсылки) Тогда
				МенеджерыОбъектов.Добавить(Справочники[ПустаяСсылка.Метаданные().Имя]);
				
			ИначеЕсли Задачи.ТипВсеСсылки(ТипСсылки).СодержитТип(ТипСсылки) Тогда	
				МенеджерыОбъектов.Добавить(Задачи[ПустаяСсылка.Метаданные().Имя]);
				
			ИначеЕсли БизнесПроцессы.ТипВсеСсылки(ТипСсылки).СодержитТип(ТипСсылки) Тогда	
				МенеджерыОбъектов.Добавить(БизнесПроцессы[ПустаяСсылка.Метаданные().Имя]);
				
			ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки(ТипСсылки).СодержитТип(ТипСсылки) Тогда
				МенеджерыОбъектов.Добавить(ПланыВидовХарактеристик[ПустаяСсылка.Метаданные().Имя]);
				
			Иначе
				ТекстИсключения = НСтр("ru = 'Ошибка распознавания штрихкода: тип ""%Тип%"" не поддерживается.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения,"%Тип%",ТипСсылки);
				
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	МассивСсылок = Новый Массив;
	ПервыйЗапрос = Истина;
	Для Каждого Менеджер Из МенеджерыОбъектов Цикл
		
		Попытка
			Ссылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Идентификатор));
		Исключение
			Продолжить;
		КонецПопытки;
		
		МетаданныеСсылки = Ссылка.Метаданные();
		Если Не ПравоДоступа("Чтение", МетаданныеСсылки) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСсылок.Добавить(Ссылка);
		
		Если ПервыйЗапрос Тогда
			Запрос.Текст = Запрос.Текст +
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ Таблица.Ссылка КАК Ссылка
			|ИЗ &МетаданныеСсылкиПолноеИмя КАК Таблица
			|ГДЕ Ссылка В (&МассивСсылок)
			|";
		Иначе	
			Запрос.Текст = Запрос.Текст + 
			"ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ Таблица.Ссылка КАК Ссылка
			|ИЗ &МетаданныеСсылкиПолноеИмя КАК Таблица
			|ГДЕ Ссылка В (&МассивСсылок)
			|";
		КонецЕсли;

		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&МетаданныеСсылкиПолноеИмя", МетаданныеСсылки.ПолноеИмя());
		ПервыйЗапрос = Ложь;
		
	КонецЦикла;
	
	Если Не ПервыйЗапрос Тогда
		Запрос.Параметры.Вставить("МассивСсылок", МассивСсылок);
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
	
КонецФункции

// Вывести штрихкод в табличный документ
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент - Табличный документ
//  Макет - ТабличныйДокумент
//  ОбластьМакета - ОбластьЯчеекТабличногоДокумента - Область
//  Ссылка - ЛюбаяСсылка - Ссылка на документ из которого будет вычислен штрихкод.
//
Процедура ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, Знач ОбластьМакета, Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыводитьШтрихкодВОтдельнуюОбласть = Ложь;
	Если Не ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакета) Тогда
		// Картинки штрихкода в этой области макета нет.
		
		Если Макет.Области.Найти("ОбластьШтрихкода") <> Неопределено Тогда
			
			// Проверить картинку штрихкода в области "Штрихкод"
			ОбластьМакетаШтрихкод = Макет.ПолучитьОбласть("ОбластьШтрихкода");
			Если ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакетаШтрихкод) Тогда
				ОбластьМакета = ОбластьМакетаШтрихкод;
				ВыводитьШтрихкодВОтдельнуюОбласть = Истина;
			Иначе
				Возврат;
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкодированиеПечатныхФормОбъектов") Тогда
		ОбластьМакета.Рисунки.Удалить(ОбластьМакета.Рисунки.КартинкаШтрихкода);
		Возврат;
	КонецЕсли;
	
	Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	РисунокКвадрат = Эталон.Рисунки.Квадрат100Пикселей; // РисунокТабличногоДокумента
	КоличествоМиллиметровВПикселе = РисунокКвадрат.Высота / 100;
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина",           Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Ширина / КоличествоМиллиметровВПикселе));
	ПараметрыШтрихкода.Вставить("Высота",           Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Высота / КоличествоМиллиметровВПикселе));
	ПараметрыШтрихкода.Вставить("Штрихкод",         СокрЛП(ЧисловойКодПоСсылке(Ссылка)));
	ПараметрыШтрихкода.Вставить("ТипВходныхДанных", 0); // Штрихкод - это строка
	ПараметрыШтрихкода.Вставить("ТипКода",          4); // Code128
	ПараметрыШтрихкода.Вставить("ОтображатьТекст",  Ложь);
	ПараметрыШтрихкода.Вставить("РазмерШрифта",     6);
	
	ОбластьМакета.Рисунки.КартинкаШтрихкода.Картинка = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода).Картинка;
	
	Если ВыводитьШтрихкодВОтдельнуюОбласть Тогда
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьДесятичноеЧислоВШестнадцатеричнуюСистемуСчисления(Знач ДесятичноеЧисло)
	
	Результат = "";
	
	Пока ДесятичноеЧисло > 0 Цикл
		ОстатокОтДеления = ДесятичноеЧисло % 16;
		ДесятичноеЧисло  = (ДесятичноеЧисло - ОстатокОтДеления) / 16;
		Результат        = Сред("0123456789abcdef", ОстатокОтДеления + 1, 1) + Результат;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПреобразоватьИзШестнадцатеричнойСистемыСчисленияВДесятичноеЧисло(Знач Значение)
	
	Значение = НРег(Значение);
	ДлинаСтроки = СтрДлина(Значение);
	
	Результат = 0;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		Результат = Результат * 16 + СтрНайти("0123456789abcdef", Сред(Значение, НомерСимвола, 1)) - 1;
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧГ=0");
	
КонецФункции

Функция ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакета)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("КартинкаШтрихкода", Новый УникальныйИдентификатор);
	СтароеЗначение = СтруктураПоиска.КартинкаШтрихкода;
	
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, ОбластьМакета.Рисунки);
	
	Возврат Не СтруктураПоиска.КартинкаШтрихкода = СтароеЗначение;
	
КонецФункции

#КонецОбласти
